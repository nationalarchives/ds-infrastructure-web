import boto3
import os

ec2 = boto3.client("ec2")
autoscaling = boto3.client("autoscaling")
route53 = boto3.client("route53")

ASG_NAME = os.environ["ASG_NAME"]
HOSTED_ZONE_ID = os.environ["HOSTED_ZONE_ID"]
RECORD_NAME = os.environ["RECORD_NAME"]


def lambda_handler(event, context):

    print(f"Received event: {event}")

    detail = event.get("detail", {})

    # Validate EventBridge event
    if (
        event.get("source") != "aws.autoscaling"
        or event.get("detail-type") != "EC2 Instance Launch Successful"
        or detail.get("AutoScalingGroupName") != ASG_NAME
    ):
        print("Ignoring unrelated event")
        return {
            "statusCode": 200,
            "message": "Ignored unrelated event"
        }

    # Get newly launched EC2 instance ID
    instance_id = detail.get("EC2InstanceId")

    if not instance_id:
        raise ValueError("EC2InstanceId missing from EventBridge event")

    print(f"New Redis instance: {instance_id}")

    # Verify instance belongs to Platform Redis ASG
    asg_response = autoscaling.describe_auto_scaling_instances(
        InstanceIds=[instance_id]
    )

    asg_instances = asg_response.get("AutoScalingInstances", [])

    if not asg_instances:
        raise ValueError(f"Instance {instance_id} not found in ASG")

    asg_instance = asg_instances[0]

    if asg_instance["AutoScalingGroupName"] != ASG_NAME:
        raise ValueError(
            f"Instance {instance_id} does not belong to {ASG_NAME}"
        )

    # Get current EC2 instance details
    ec2_response = ec2.describe_instances(
        InstanceIds=[instance_id]
    )

    reservations = ec2_response.get("Reservations", [])

    if not reservations or not reservations[0].get("Instances"):
        raise ValueError(f"EC2 instance {instance_id} not found")

    instance = reservations[0]["Instances"][0]

    # Verify instance is running
    instance_state = instance["State"]["Name"]

    if instance_state != "running":
        raise ValueError(
            f"Instance {instance_id} is not running: {instance_state}"
        )

    # Get new private IP
    private_ip = instance.get("PrivateIpAddress")

    if not private_ip:
        raise ValueError(
            f"No private IP found for instance {instance_id}"
        )

    print(f"New Redis private IP: {private_ip}")

    # Update Route 53 A record
    route53_response = route53.change_resource_record_sets(
        HostedZoneId=HOSTED_ZONE_ID,
        ChangeBatch={
            "Comment": f"Update Redis DNS for instance {instance_id}",
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": RECORD_NAME,
                        "Type": "A",
                        "TTL": 15,
                        "ResourceRecords": [
                            {
                                "Value": private_ip
                            }
                        ]
                    }
                }
            ]
        }
    )

    change_id = route53_response["ChangeInfo"]["Id"]

    print(
        f"Updated {RECORD_NAME} -> {private_ip} "
        f"(Instance: {instance_id}, Change: {change_id})"
    )

    return {
        "statusCode": 200,
        "record": RECORD_NAME,
        "instance_id": instance_id,
        "private_ip": private_ip,
        "route53_change_id": change_id
    }
    