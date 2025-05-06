import boto3
import time

def wagtail_cron_trigger(event, context):
    ec2_client = boto3.client('ec2')
    ssm_client = boto3.client('ssm')
    
    instance_name = 'wagtail'
    
    response = ec2_client.describe_instances(
        Filters=[{
            'Name': 'tag:Name',
            'Values': [instance_name]
        }]
    )
    
    if not response['Reservations']:
        return {
            'statusCode': 404,
            'body': f'Instance with name "{instance_name}" not found.'
        }

    instance_id = response['Reservations'][0]['Instances'][0]['InstanceId']
    print(f"Found EC2 instance with ID: {instance_id}")
    
    docker_ps_command = "docker ps --filter 'status=running' --format '{{.Names}}'"
    print(f"Running Docker command: {docker_ps_command}")
    
    try:
        ps_response = ssm_client.send_command(
            InstanceIds=[instance_id],
            DocumentName='AWS-RunShellScript',
            Parameters={'commands': [docker_ps_command]},
        )

        command_id = ps_response['Command']['CommandId']
        print(f"Sent SSM command to get running containers, Command ID: {command_id}")
    
    except Exception as e:
        print(f"Error sending command: {e}")
        return {
            'statusCode': 500,
            'body': f"Error sending command to EC2: {str(e)}"
        }

    time.sleep(30)  # Adjust or implement a loop with a timeout

    try:
        output = ssm_client.get_command_invocation(CommandId=command_id, InstanceId=instance_id)
        print(f"Command result: {output}")
    
        if output['Status'] != 'Success':
            print(f"Error: {output['StandardErrorContent']}")
            return {
                'statusCode': 500,
                'body': f"Failed to get running containers: {output['StandardErrorContent']}"
            }

        containers = output['StandardOutputContent'].splitlines()
        print(f"Running containers: {containers}")

        if 'blue-web' in containers:
            active_container = 'blue-web'
        elif 'green-web' in containers:
            active_container = 'green-web'
        else:
            return {
                'statusCode': 500,
                'body': 'No active wagtail containers found.'
            }

    except Exception as e:
        print(f"Error getting command invocation result: {e}")
        return {
            'statusCode': 500,
            'body': f"Error getting command invocation result: {str(e)}"
        }

    task = event.get('task')
    if task == 'publish_scheduled':
        cron_command = f"sudo docker-compose -f /var/docker/compose.yml exec {active_container} manage publish_scheduled"
    elif task == 'clearsessions':
        cron_command = f"sudo docker-compose -f /var/docker/compose.yml exec {active_container} manage clearsessions"
    else:
        return {
            'statusCode': 400,
            'body': 'Invalid task specified.'
        }

    print(f"Running task command: {cron_command}")

    try:
        task_response = ssm_client.send_command(
            InstanceIds=[instance_id],
            DocumentName='AWS-RunShellScript',
            Parameters={'commands': [cron_command]},
        )

        task_command_id = task_response['Command']['CommandId']
        print(f"Sent task command to EC2, Task Command ID: {task_command_id}")
    
    except Exception as e:
        print(f"Error sending task command: {e}")
        return {
            'statusCode': 500,
            'body': f"Error sending task command: {str(e)}"
        }

    time.sleep(20)  

    try:
        result = ssm_client.get_command_invocation(CommandId=task_command_id, InstanceId=instance_id)
        print(f"Task command result: {result}")
    
        if result['Status'] != 'Success':
            print(f"Error: {result['StandardErrorContent']}")
            return {
                'statusCode': 500,
                'body': f"Task failed: {result['StandardErrorContent']}"
            }

        return {
            'statusCode': 200,
            'body': f'Task "{task}" executed successfully on "{active_container}". Output: {result["StandardOutputContent"]}'
        }

    except Exception as e:
        print(f"Error getting task command invocation result: {e}")
        return {
            'statusCode': 500,
            'body': f"Error getting task command invocation result: {str(e)}"
        }
