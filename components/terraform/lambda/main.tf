data "archive_file" "web_docker_deployment" {
    type        = "zip"
    source_dir  = "${path.root}/lambda/web-docker-deployment/source"
    output_path = "${path.root}/lambda/web-docker-deployment/web-docker-deployment.zip"
}

# web-docker-deployment
#
resource "aws_lambda_function" "web_docker_deployment" {
    filename         = data.archive_file.web_docker_deployment.output_path
    source_code_hash = data.archive_file.web_docker_deployment.output_base64sha256

    function_name = "web_docker_deployment"
    role          = var.web_docker_deployment_role_arn

    layers = var.layers

    handler = "web-docker-deployment.web_docker_deployment"
    runtime = "python3.11"

    memory_size = 512
    timeout     = 300

    ephemeral_storage {
        size = 512
    }

    vpc_config {
        subnet_ids         = var.subnet_ids
        security_group_ids = var.security_group_ids
    }

    tags = merge(var.tags, {
        Role            = "serverless"
        ApplicationType = "python"
        CreatedBy       = "devops@nationalarchives.gov.uk"
        Service         = "web-docker-deployment"
        Name            = "web_docker_deployment"
    })
}

# using this option allows setting of log retention and removal of the log group
# when the function is destroyed
resource "aws_cloudwatch_log_group" "web_docker_deployment" {
    name              = "/aws/lambda/${aws_lambda_function.web_docker_deployment.function_name}"
    retention_in_days = 7
}
