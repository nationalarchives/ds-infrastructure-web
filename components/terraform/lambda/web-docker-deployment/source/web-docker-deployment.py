import boto3
import datetime


def web_docker_deployment(event, context):
    # Define the tag possessed by the EC2 instances that we want to execute the script on
    tag = 'web-frontend'

    docker_tag = event["docker_tag"]

    script = '''
    /usr/local/bin/load-docker.sh -t ''' + docker_tag

    ec2_client = boto3.client('ec2', region_name='eu-west-2')
    ssm_client = boto3.client('ssm', region_name='eu-west-2')

    filtered_instances = ec2_client.describe_instances(Filters=[{'Name': 'tag:Name', 'Values': [tag]}])
    reservations = filtered_instances['Reservations']

    exec_list = []
    for reservation in reservations:
        print("Following instances found:")
        for instance in reservation['Instances']:
            print(instance['InstanceId'], " is ", instance['State']['Name'])
            if instance['State']['Name'] == 'running':
                exec_list.append(instance['InstanceId'])
                print("  --> queued for deployment")

        print("**************")

    response = ssm_client.send_command(
        DocumentName='AWS-RunShellScript',
        DocumentVersion='$LATEST',
        Parameters={'commands': [script]},
        InstanceIds=exec_list
    )

    # See the command run on the target instance Ids
    print(response['Command']['Parameters']['commands'])
