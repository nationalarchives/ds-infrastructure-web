import boto3
import os

ec2 = boto3.client("ec2")
autoscaling = boto3.client("autoscaling")
route53 = boto3.client("route53")

ASG_NAME = os.environ["ASG_NAME"]
HOSTED_ZONE_ID = os.environ["HOSTED_ZONE_ID"]
RECORD_NAME = os.environ["RECORD_NAME"]


def lambda_handler(event, context):
    # Find instances belonging to the Platform Redis ASG
    response = autoscaling.describe_auto_scaling_instances()

    instance_ids = [
        item["InstanceId"]
        for item in response["AutoScalingInstances"]
        if item["AutoScalingGroupName"] == ASG_NAME
        and item["LifecycleState"] == "InService"
    ]

    if not instance_ids:
        raise Exception(
            f"No InService instances found for ASG {ASG_NAME}"
        )

    # Get the private IP of the Redis instance
    instances = ec2.describe_instances(
        InstanceIds=instance_ids
    )

    private_ips = []

    for reservation in instances["Reservations"]:
        for instance in reservation["Instances"]:
            if instance.get("PrivateIpAddress"):
                private_ips.append(instance["PrivateIpAddress"])

    if not private_ips:
        raise Exception(
            f"No private IP found for ASG {ASG_NAME}"
        )

    # Redis ASG normally has one InService instance.
    # Use the first one if there is temporarily more than one.
    private_ip = private_ips[0]

    # Update Route 53
    route53.change_resource_record_sets(
        HostedZoneId=HOSTED_ZONE_ID,
        ChangeBatch={
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
                        ],
                    },
                }
            ]
        },
    )

    print(
        f"Updated {RECORD_NAME} -> {private_ip}"
    )

    return {
        "statusCode": 200,
        "record": RECORD_NAME,
        "private_ip": private_ip,
    }
