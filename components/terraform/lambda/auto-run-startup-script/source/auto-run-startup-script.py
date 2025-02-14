import json
import time
import boto3
import os

def get_instance_id_by_name(instance_name):
    ec2_client = boto3.client('ec2', region_name="eu-west-2")

    # Fetch instances based on the tag Name
    response = ec2_client.describe_instances(
        Filters=[
            {
                'Name': 'tag:Name',  
                'Values': [instance_name]
            }
        ]
    )

    # Extract the instance ID from the response
    reservations = response['Reservations']
    if not reservations:
        raise ValueError(f"No instances found with the name {instance_name}")

    # Assuming only one instance is returned per environment
    instance_id = reservations[0]['Instances'][0]['InstanceId']
   
    return instance_id

def lambda_handler(event, context):
    # Set your environment and instance name (web-frontend) dynamically, as needed
    environment = os.getenv('ENVIRONMENT', 'dev')  
    instance_name = "web-frontend"  
    try:
        # Step 1: Get the EC2 instance ID based on the name tag
        instance_id = get_instance_id_by_name(instance_name)
        print(f"Found instance ID: {instance_id} for {environment} environment")

        ssm_client = boto3.client("ssm", region_name="eu-west-2")
        parameter_name = "/application/web/frontend/deployed_version"
        deployed_version = event.get("deployed_version", "").strip()

        # Command to execute startup.sh
        command = "/usr/local/bin/startup.sh"

        # Step 2: Send command to run startup.sh
        response = ssm_client.send_command(
            InstanceIds=[instance_id],
            DocumentName="AWS-RunShellScript",
            Parameters={"commands": [command]},
        )
        command_id = response['Command']['CommandId']
        print(f"Command sent. ID: {command_id}")

        # Step 3: Wait for completion
        for _ in range(5):  
            time.sleep(5)
            output_response = ssm_client.get_command_invocation(
                CommandId=command_id,
                InstanceId=instance_id
            )
            status = output_response['Status']
            print(f"Current Status: {status}")

            if status in ["Success", "Failed", "TimedOut", "Cancelled"]:
                break  # Exit loop if command execution is done

        # Step 4: Check final status
        if status == "Success":
            if deployed_version:
                ssm_client.put_parameter(
                    Name=parameter_name,
                    Value=deployed_version,
                    Type="String",
                    Overwrite=True,
                )
                return {
                    "statusCode": 200,
                    "body": json.dumps(f"Deployed version {deployed_version} updated successfully.")
                }
            else:
                return {
                    "statusCode": 400,
                    "body": json.dumps("No deployed_version provided.")
                }
        else:
            return {
                "statusCode": 500,
                "body": json.dumps(f"Error: startup.sh failed with status {status}")
            }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps(f"Error: {str(e)}")
        }