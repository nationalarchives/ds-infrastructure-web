import json
import time
import boto3
import os

def get_instance_id_by_name(instance_name):
    ec2_client = boto3.client('ec2', region_name="eu-west-2")

    response = ec2_client.describe_instances(
        Filters=[
            {'Name': 'tag:Name', 'Values': [instance_name]},
            {'Name': 'instance-state-name', 'Values': ['running']}
        ]
    )

    reservations = response['Reservations']
    if not reservations:
        raise ValueError(f"No running instances found with the name {instance_name}")

    return reservations[0]['Instances'][0]['InstanceId']

def lambda_handler(event, context):
    environment = os.getenv('ENVIRONMENT', 'dev')
    instance_name = "web-frontend"

    try:
        instance_id = get_instance_id_by_name(instance_name)
        print(f"Found instance ID: {instance_id} for {environment} environment")

        ssm_client = boto3.client("ssm", region_name="eu-west-2")
        parameter_name = "/application/web/frontend/deployed_version"
        deployed_version = event.get("deployed_version", "").strip()

        if not deployed_version:
            return {"statusCode": 400, "body": json.dumps("Error: deployed_version not provided.")}

        command = "/usr/local/bin/startup.sh"
        response = ssm_client.send_command(
            InstanceIds=[instance_id],
            DocumentName="AWS-RunShellScript",
            Parameters={"commands": [command]},
        )

        command_id = response['Command']['CommandId']
        print(f"Command sent. ID: {command_id}")

        for _ in range(15):  
            time.sleep(5)
            output_response = ssm_client.get_command_invocation(
                CommandId=command_id,
                InstanceId=instance_id
            )
            status = output_response['Status']
            print(f"Current Status: {status}")

            if status in ["Success", "Failed", "TimedOut", "Cancelled"]:
                break  

        if status == "Success":
            ssm_client.put_parameter(
                Name=parameter_name,
                Value=deployed_version,
                Type="String",
                Overwrite=True,
            )
            return {"statusCode": 200, "body": json.dumps(f"Deployed version {deployed_version} updated successfully.")}
        else:
            return {"statusCode": 500, "body": json.dumps(f"Error: startup.sh failed with status {status}")}

    except Exception as e:
        return {"statusCode": 500, "body": json.dumps(f"Error: {str(e)}")}
    