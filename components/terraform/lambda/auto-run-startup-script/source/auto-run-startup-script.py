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

def get_docker_image_version_from_ssm():
    ssm_client = boto3.client("ssm", region_name="eu-west-2")
    docker_images_param = "/application/web/frontend/docker_images"  # Updated path
   
    try:
        response = ssm_client.get_parameter(Name=docker_images_param)
        return response['Parameter']['Value']
    except Exception as e:
        print(f"Error retrieving docker images version from SSM: {str(e)}")
        return None

def lambda_handler(event, context):
    environment = os.getenv('ENVIRONMENT', 'dev')
    instance_name = "web-frontend"
   
    try:
        # Get the current deployed version from the event
        deployed_version = event.get("deployed_version", "").strip()

        # Get the latest version from docker_images in SSM
        latest_version = get_docker_image_version_from_ssm()

        if not latest_version:
            return {"statusCode": 500, "body": json.dumps("Error: Failed to retrieve latest docker image version from SSM.")}

        if deployed_version == latest_version:
            print(f"No change in docker image version. Current deployed version: {deployed_version}")
            return {"statusCode": 200, "body": json.dumps("No new deployment needed. Current version is up-to-date.")}

        # Instance found
        instance_id = get_instance_id_by_name(instance_name)
        print(f"Found instance ID: {instance_id} for {environment} environment")

        ssm_client = boto3.client("ssm", region_name="eu-west-2")
        command = "/usr/local/bin/startup.sh"

        response = ssm_client.send_command(
            InstanceIds=[instance_id],
            DocumentName="AWS-RunShellScript",
            Parameters={"commands": [command]},
        )

        command_id = response['Command']['CommandId']
        print(f"Command sent. ID: {command_id}")

        # Wait for command to complete and check the status
        for _ in range(10):
            time.sleep(5)
            output_response = ssm_client.get_command_invocation(
                CommandId=command_id,
                InstanceId=instance_id
            )
            status = output_response['Status']
            output = output_response.get('StandardOutputContent', '')

            print(f"Current Status: {status}")
            print(f"Command Output: {output}")

            if status in ["Success", "Failed", "TimedOut", "Cancelled"]:
                # Check if the script output contains "startup completed"
                if "startup completed" in output:
                    status = "Success"
                break

        if status == "Success":
            # Once startup.sh has completed successfully, update the deployed version
            ssm_client.put_parameter(
                Name="/application/web/frontend/deployed_version",  # Updated path
                Value=latest_version,
                Type="String",
                Overwrite=True,
            )
            return {"statusCode": 200, "body": json.dumps(f"Deployment successful. Deployed version updated to {latest_version}.")}
        else:
            return {"statusCode": 500, "body": json.dumps(f"Error: startup.sh failed with status {status}. Output: {output}")}

    except Exception as e:
        return {"statusCode": 500, "body": json.dumps(f"Error: {str(e)}")}