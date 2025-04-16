import json
import time
import boto3
import os
import re

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

def get_docker_image_version_from_ssm(service):
    ssm_client = boto3.client("ssm", region_name="eu-west-2")
    docker_images_param = f"/application/web/{service}/docker_images"

    try:
        response = ssm_client.get_parameter(Name=docker_images_param)
        return response['Parameter']['Value']
    except Exception as e:
        print(f"Error retrieving docker images version for {service} from SSM: {str(e)}")
        raise Exception(f"Failed to retrieve docker image version for {service} from SSM")

def get_deployed_version_from_ssm(service):
    ssm_client = boto3.client("ssm", region_name="eu-west-2")
    deployed_version_param = f"/application/web/{service}/deployed_version"

    try:
        response = ssm_client.get_parameter(Name=deployed_version_param)
        return response['Parameter']['Value']
    except Exception as e:
        print(f"Error retrieving deployed version for {service} from SSM: {str(e)}")
        return None

def extract_all_versions(docker_image_string):
    # Regex to match versions with various formats
    version_pattern = r"(\d{2}\.\d{2}\.\d{2}\.\d+)"
    match = re.findall(version_pattern, docker_image_string)
    return match

def deploy_service(service, instance_name):
    try:
        # Map 'cms' to 'wagtail' for SSM parameters
        ssm_service_name = "wagtail" if service == "cms" else service

        # Get the deployed version from SSM
        deployed_version = get_deployed_version_from_ssm(ssm_service_name)
        if not deployed_version:
            return {"statusCode": 500, "body": json.dumps(f"Error: Failed to retrieve deployed version for {service} from SSM.")}

        # Get the latest version string from docker_images in SSM
        latest_version_string = get_docker_image_version_from_ssm(ssm_service_name)
        latest_versions = extract_all_versions(latest_version_string)

        if not latest_versions:
            return {"statusCode": 500, "body": json.dumps(f"Error: Failed to extract version from docker image string for {service}.")}

        # If the versions are the same, no need to redeploy
        if deployed_version in latest_versions:
            print(f"Docker image version for {service}. Current deployed version: {deployed_version}")
            return {"statusCode": 200, "body": json.dumps(f"Deployed version for {service}: {deployed_version}")}

        # Get the instance ID of the server
        instance_id = get_instance_id_by_name(instance_name)
        print(f"Found instance ID: {instance_id} for {service}")

        # Run the startup.sh on the instance
        ssm_client = boto3.client("ssm", region_name="eu-west-2")
        command = "/usr/local/bin/startup.sh"

        response = ssm_client.send_command(
            InstanceIds=[instance_id],
            DocumentName="AWS-RunShellScript",
            Parameters={"commands": [command]},
        )

        command_id = response['Command']['CommandId']
        print(f"Command sent for {service}. ID: {command_id}")

        # Wait for command to complete and check status
        MAX_RETRIES = 18
        for attempt in range(MAX_RETRIES):
            time.sleep(10)
            output_response = ssm_client.get_command_invocation(
                CommandId=command_id,
                InstanceId=instance_id
            )
            status = output_response['Status']
            output = output_response.get('StandardOutputContent', '')

            print(f"Attempt {attempt+1} for {service}: Current Status: {status}")
            print(f"Command Output: {output}")

            if status in ["Success", "Failed", "TimedOut", "Cancelled"]:
                if "startup completed" in output:
                    status = "Success"
                break

        if status == "Success":
            # Update the deployed version in SSM after successful startup
            latest_version = latest_versions[0]  # Take the first version from the list
            ssm_client.put_parameter(
                Name=f"/application/web/{ssm_service_name}/deployed_version",
                Value=latest_version,
                Type="String",
                Overwrite=True,
            )
            return {"statusCode": 200, "body": json.dumps(f"Deployment successful for {service}. Deployed version updated to {latest_version}.")}
        else:
            return {"statusCode": 500, "body": json.dumps(f"Error: startup.sh failed for {service} with status {status}. Output: {output}")}

    except Exception as e:
        return {"statusCode": 500, "body": json.dumps(f"Error deploying {service}: {str(e)}")}

def lambda_handler(event, context):
    environment = os.getenv('ENVIRONMENT', 'dev')

    # List of services and their instance names
    services = {
        "frontend": "web-frontend",
        "enrichment": "web-enrichment",
        "cms": "wagtail"
    }

    results = {}
    for service, instance_name in services.items():
        results[service] = deploy_service(service, instance_name)

    return results
