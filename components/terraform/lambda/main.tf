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
    runtime = "python3.12"

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


data "archive_file" "auto_run_startup_script" {
  type        = "zip"
  source_dir  = "${path.root}/lambda/auto-run-startup-script/source"
  output_path = "${path.root}/lambda/auto-run-startup-script/auto-run-startup-script.zip"
}

# Lambda Function: AutoRunStartupScript
resource "aws_lambda_function" "auto_run_startup_script" {
  filename         = data.archive_file.auto_run_startup_script.output_path
  source_code_hash = data.archive_file.auto_run_startup_script.output_base64sha256

  function_name = "AutoRunStartupScript"
  role          = var.auto_run_startup_script_role_arn

  handler = "auto-run-startup-script.lambda_handler"  
  runtime = "python3.12"

  memory_size = 128
  timeout     = 900

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
    Service         = "auto-run-startup-script"
    Name            = "auto_run_startup_script"
  })
}

# CloudWatch Log Group for AutoRunStartupScript Lambda
resource "aws_cloudwatch_log_group" "auto_run_startup_script" {
  name              = "/aws/lambda/AutoRunStartupScript"
  retention_in_days = 7
}

data "archive_file" "wagtail_cron_trigger" {
  type        = "zip"
  source_dir  = "${path.root}/lambda/wagtail-cron-trigger/source"
  output_path = "${path.root}/lambda/wagtail-cron-trigger/wagtail-cron-trigger.zip"
}

# Lambda Function: WagtailCronTrigger
resource "aws_lambda_function" "wagtail_cron_trigger" {
  filename         = data.archive_file.wagtail_cron_trigger.output_path
  source_code_hash = data.archive_file.wagtail_cron_trigger.output_base64sha256

  function_name = "WagtailCronTrigger"
  role          = var.wagtail_cron_trigger_role_arn

  handler = "wagtail-cron-trigger.wagtail_cron_trigger"  
  runtime = "python3.12"

  memory_size = 128
  timeout     = 900

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
    Service         = "wagtail-cron-trigger"
    Name            = "wagtail_cron_trigger"
  })
}

# CloudWatch Log Group for WagtailCronTrigger Lambda
resource "aws_cloudwatch_log_group" "wagtail_cron_trigger" {
  name              = "/aws/lambda/WagtailCronTrigger"
  retention_in_days = 7
}


resource "aws_sqs_queue" "process_submitted_files_queue" {
  count = var.environment == "live" ? 1 : 0
  name = "process-submitted-files-queue"
  visibility_timeout_seconds = 360
  message_retention_seconds  = 1209600
}

resource "aws_s3_bucket_notification" "submitted_folder_event" {
  count = var.environment == "live" ? 1 : 0
  bucket = var.foi_s3_bucket
  eventbridge = true

  queue {
    queue_arn     = aws_sqs_queue.process_submitted_files_queue[0].arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "submitted/"
  }

  depends_on = [aws_sqs_queue.process_submitted_files_queue]
}

resource "aws_lambda_function" "process_submitted_files" {
  count = var.environment == "live" ? 1 : 0

  function_name = "process-submitted-files"
  role          = var.web_request_service_record_role_arn
  handler       = "process-submitted-files.lambda_handler"
  runtime       = "python3.12"
  timeout       = 300


  filename = "${path.module}/process-submitted-files/process-submitted-files.zip"

  environment {
    variables = {
      BUCKET_NAME      = var.foi_s3_bucket
      PLACEHOLDER_IMAGE = "${path.module}/source/placeholder.jpg"
    }
  }

  depends_on = [aws_sqs_queue.process_submitted_files_queue]
}
resource "aws_lambda_event_source_mapping" "process_submitted_files_sqs" {
  count = var.environment == "live" ? 1 : 0
  event_source_arn = aws_sqs_queue.process_submitted_files_queue[0].arn
  function_name    = aws_lambda_function.process_submitted_files[0].arn
  batch_size       = 1
  enabled          = true

  depends_on = [
    aws_lambda_function.process_submitted_files,
    aws_sqs_queue.process_submitted_files_queue
  ]
}