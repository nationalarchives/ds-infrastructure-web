import json
import time
import boto3
import os
import re

def get_instance_ids_by_name(instance_name):
    ec2_client = boto3.client('ec2', region_name="eu-west-2")
    response = ec2_client.describe_instances(
        Filters=[
            {'Name': 'tag:Name', 'Values': [instance_name]},
            {'Name': 'instance-state-name', 'Values': ['running']}
        ]
    )
    instance_ids = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_ids.append(instance['InstanceId'])
    if not instance_ids:
        raise ValueError(f"No running instances found with the name {instance_name}")
    return instance_ids

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
    version_pattern = r"(\d{2}\.\d{2}\.\d{2}\.\d+)"
    matches = re.findall(version_pattern, docker_image_string)
    if matches:
        return matches
    else:
        return [docker_image_string.strip()]

def run_command_on_instances(instance_ids, command):
    ssm_client = boto3.client("ssm", region_name="eu-west-2")
    command_ids = {}
    for instance_id in instance_ids:
        response = ssm_client.send_command(
            InstanceIds=[instance_id],
            DocumentName="AWS-RunShellScript",
            Parameters={"commands": [command]},
        )
        command_id = response['Command']['CommandId']
        command_ids[instance_id] = command_id
        print(f"Sent command to instance {instance_id}. Command ID: {command_id}")
    return command_ids

def wait_for_commands(command_ids):
    ssm_client = boto3.client("ssm", region_name="eu-west-2")
    MAX_RETRIES = 18
    results = {}
    for instance_id, command_id in command_ids.items():
        for attempt in range(MAX_RETRIES):
            time.sleep(10)
            output_response = ssm_client.get_command_invocation(
                CommandId=command_id,
                InstanceId=instance_id
            )
            status = output_response['Status']
            output = output_response.get('StandardOutputContent', '')
            print(f"Attempt {attempt+1} for instance {instance_id}: Status: {status}")
            print(f"Output: {output}")
            if status in ["Success", "Failed", "TimedOut", "Cancelled"]:
                if "Traefik recognizes" in output:
                    status = "Success"
                results[instance_id] = (status, output)
                break
        else:
            results[instance_id] = ("Timeout", "")
    return results

def deploy_service(service, instance_name):
    try:
        ssm_service_name = service
        deployed_version = get_deployed_version_from_ssm(ssm_service_name)
        if not deployed_version:
            return {"statusCode": 500, "body": json.dumps(f"Error: Failed to retrieve deployed version for {service} from SSM.")}
        latest_version_string = get_docker_image_version_from_ssm(ssm_service_name)
        latest_versions = extract_all_versions(latest_version_string)
        if not latest_versions:
            return {"statusCode": 500, "body": json.dumps(f"Error: Failed to extract version from docker image string for {service}.")}
        if deployed_version in latest_versions:
            print(f"Docker image version for {service}. Current deployed version: {deployed_version}")
            return {"statusCode": 200, "body": json.dumps(f"Deployed version for {service}: {deployed_version}")}
        instance_ids = get_instance_ids_by_name(instance_name)
        print(f"Found {len(instance_ids)} running instance(s) for {service}: {instance_ids}")
        command_ids = run_command_on_instances(instance_ids, "/usr/local/bin/startup.sh")
        results = wait_for_commands(command_ids)
        all_success = all(status == "Success" for status, _ in results.values())
        if all_success:
            docker_images_json = json.loads(latest_version_string)
            frontend_image = docker_images_json.get("frontend-application", "")
            frontend_tag = frontend_image.split(":")[-1] if ":" in frontend_image else frontend_image
            if re.match(r"^\d{2}\.\d{2}\.\d{2}\.\d+$", frontend_tag):
                version_to_store = frontend_tag
            else:
                version_to_store = frontend_tag
            boto3.client("ssm", region_name="eu-west-2").put_parameter(
                Name=f"/application/web/{ssm_service_name}/deployed_version",
                Value=version_to_store,
                Type="String",
                Overwrite=True,
            )
            return {"statusCode": 200, "body": json.dumps(f"Deployment successful for {service}. Updated to version {version_to_store}.")}
        else:
            failed_instances = {iid: res for iid, res in results.items() if res[0] != "Success"}
            return {"statusCode": 500, "body": json.dumps(f"Deployment failed on some instances for {service}: {failed_instances}")}
    except Exception as e:
        return {"statusCode": 500, "body": json.dumps(f"Error deploying {service}: {str(e)}")}

def lambda_handler(event, context):
    environment = os.getenv('ENVIRONMENT', 'dev')
    services = {
        "frontend": "web-frontend",
        "enrichment": "web-enrichment",
        "wagtail": "wagtail"
    }
    results = {}
    for service, instance_name in services.items():
        results[service] = deploy_service(service, instance_name)
    return results
