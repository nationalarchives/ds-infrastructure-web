import json
import os
import re
from datetime import datetime, timezone

import boto3

autoscaling = boto3.client("autoscaling")
ec2 = boto3.client("ec2")
sns = boto3.client("sns")

SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]


def parse_event_time(value):
    if not value:
        return None

    try:
        return datetime.fromisoformat(
            value.replace("Z", "+00:00")
        ).astimezone(timezone.utc)
    except (ValueError, TypeError):
        return None


def get_cpu_scaling_activity(
    asg_name,
    instance_id,
    event_time,
    event_type
):
    if not instance_id or not event_time:
        return None

    # Match the correct CPU alarm to the scaling direction
    alarm_suffixes = {
        "EC2 Instance Launch Successful": "scale-out",
        "EC2 Instance Terminate Successful": "scale-in",
    }

    suffix = alarm_suffixes.get(event_type)

    if not suffix:
        return None

    expected_alarm = f"{asg_name}-{suffix}"

    paginator = autoscaling.get_paginator(
        "describe_scaling_activities"
    )

    for page in paginator.paginate(
        AutoScalingGroupName=asg_name,
        PaginationConfig={"MaxItems": 100}
    ):
        for activity in page.get("Activities", []):
            description = activity.get("Description", "") or ""
            details = activity.get("Details", "") or ""
            cause = activity.get("Cause", "") or ""

            if not isinstance(details, str):
                details = json.dumps(details)

            # Confirm this activity concerns the affected EC2 instance
            if instance_id not in (description + details):
                continue

            start_time = activity.get("StartTime")

            if not start_time:
                continue

            start_time = start_time.astimezone(timezone.utc)

            time_difference = (
                event_time - start_time
            ).total_seconds()

            # Allow for AWS event delivery and activity timing
            if not (-120 <= time_difference <= 3600):
                continue

            # Only accept the matching CPU CloudWatch alarm
            # Use exact alarm-name matching, not partial substring matching
            alarm_pattern = (
                r"(?<![A-Za-z0-9_-])"
                + re.escape(expected_alarm)
                + r"(?![A-Za-z0-9_-])"
            )

            if not re.search(alarm_pattern, cause):
                continue

            return activity

    return None


def extract_alarm_name(cause):
    patterns = [
        r"""alarm\s+['"]([^'"]+)['"]""",
        r"""alarm\s+(\S+)\s+in\s+state""",
    ]

    for pattern in patterns:
        match = re.search(
            pattern,
            cause,
            flags=re.IGNORECASE
        )

        if match:
            return match.group(1)

    return "Not available"


def lambda_handler(event, context):
    detail = event.get("detail", {})

    asg_name = detail.get("AutoScalingGroupName", "")
    event_type = event.get("detail-type", "")
    instance_id = detail.get("EC2InstanceId")

    # Only process Web Auto Scaling Groups
    if not asg_name.startswith("web-"):
        return {
            "status": "ignored",
            "reason": "Not a web ASG"
        }

    actions = {
        "EC2 Instance Launch Successful": "Scale Out",
        "EC2 Instance Terminate Successful": "Scale In",
    }

    if event_type not in actions:
        return {
            "status": "ignored",
            "reason": "Not a supported instance event"
        }

    event_time = parse_event_time(
        event.get("time")
    )

    # Confirm the instance event was caused by
    # the matching CPU-based scaling alarm
    activity = get_cpu_scaling_activity(
        asg_name,
        instance_id,
        event_time,
        event_type
    )

    if not activity:
        print(
            f"Ignoring event for {asg_name}, "
            f"instance {instance_id}: "
            "no matching CPU alarm scaling activity"
        )

        return {
            "status": "ignored",
            "reason": "Not confirmed as CPU-based scaling"
        }

    scaling_reason = activity.get(
        "Cause",
        "Not available"
    )

    alarm_name = (
        f"{asg_name}-scale-out"
        if event_type == "EC2 Instance Launch Successful"
        else f"{asg_name}-scale-in"
    )

    # Get Auto Scaling Group details
    response = autoscaling.describe_auto_scaling_groups(
        AutoScalingGroupNames=[asg_name]
    )

    groups = response.get("AutoScalingGroups", [])

    if not groups:
        return {
            "status": "ignored",
            "reason": "ASG not found"
        }

    group = groups[0]
    instances = group.get("Instances", [])

    instance_ids = [
        instance["InstanceId"]
        for instance in instances
    ]

    # Get EC2 instance details
    ec2_details = {}

    if instance_ids:
        result = ec2.describe_instances(
            InstanceIds=instance_ids
        )

        for reservation in result.get("Reservations", []):
            for instance in reservation.get("Instances", []):
                ec2_details[
                    instance["InstanceId"]
                ] = instance

    # Build Slack notification
    lines = [
        f"*Auto Scaling Group:* {asg_name}",
        f"*Account:* {event.get('account', 'unknown')}",
        f"*Region:* {event.get('region', 'unknown')}",
        f"*Event:* CPU-based {actions[event_type]}",
        f"*Triggered at:* {event.get('time', 'unknown')}",
        "",
        f"*CloudWatch Alarm:* {alarm_name}",
        f"*Scaling Reason:* {scaling_reason}",
        f"*Affected Instance:* {instance_id}",
        "",
        f"*Desired Capacity:* {group['DesiredCapacity']}",
        f"*Minimum Capacity:* {group['MinSize']}",
        f"*Maximum Capacity:* {group['MaxSize']}",
        "",
        "*Current Instances:*"
    ]

    if not instances:
        lines.append(
            "No instances currently registered"
        )

    for instance in instances:
        current_instance_id = instance["InstanceId"]

        details = ec2_details.get(
            current_instance_id,
            {}
        )

        lines.append(
            f"{current_instance_id} | "
            f"state: {instance['LifecycleState']} | "
            f"health: {instance['HealthStatus']} | "
            f"type: {details.get('InstanceType', 'unknown')} | "
            f"zone: {instance.get('AvailabilityZone', 'unknown')}"
        )

    notification = {
        "version": "1.0",
        "source": "custom",
        "content": {
            "textType": "client-markdown",
            "title": (
                f"CPU Auto Scaling - "
                f"{actions[event_type]} - {asg_name}"
            ),
            "description": "\n".join(lines)
        }
    }

    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Message=json.dumps(notification)
    )

    print(
        f"CPU scaling notification published: "
        f"{asg_name}, {instance_id}, {event_type}"
    )

    return {
        "status": "published",
        "asg": asg_name,
        "instance_id": instance_id,
        "event": event_type,
        "alarm": alarm_name
    }
