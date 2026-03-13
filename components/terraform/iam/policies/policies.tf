##########################################
# IAM Policy: Deployment S3 Access
##########################################
resource "aws_iam_policy" "deployment_s3" {
    name        = "web-deployment-source-s3-policy"
    description = "deployment S3 access for web"

    policy = templatefile("${path.module}/templates/deployment-source-s3-access.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = var.service
    })
}

##########################################
# IAM Policy: Lambda Web Docker Deployment
##########################################
resource "aws_iam_policy" "lambda_web_docker_deployment_policy" {
    name        = "lambda-web-docker-deployment-policy"
    description = "receive instance data and manipulate status"

    policy = templatefile("${path.module}/templates/lambda-web-docker-deployment-policy.json", {
        account_id = var.account_id
    })
}

##########################################
# IAM Policy: SSM Access for Web Frontend
##########################################
resource "aws_iam_policy" "web_ssm" {
   name        = "web-frontend-ssm-policy"
   description = "SSM access to web frontend server"
   policy = templatefile("${path.module}/templates/instance-ssm-policy.json", {
       account_id = var.account_id
   })
}

##########################################
# IAM Policy: S3 Copy from Holding to Submitted
##########################################
resource "aws_iam_policy" "web_request_s3_copy_policy" {
  name        = "web-request-s3-copy-policy"
  description = "Policy to copy objects from holding to submitted"

  policy = templatefile("${path.module}/templates/foi-s3-copy-policy.json", {
    foi_s3_bucket = var.foi_s3_bucket
  })
}
##########################################
# SQS Queue for Submitted Files
##########################################
resource "aws_sqs_queue" "process_submitted_files_queue" {
  count                     = var.environment == "live" ? 1 : 0
  name                      = "process-submitted-files-queue"
  visibility_timeout_seconds = 360
  message_retention_seconds  = 1209600
}

##########################################
# IAM Policy: Allow Lambda to read from SQS
##########################################
resource "aws_iam_policy" "lambda_web_request_rsr_sqs" {
  count = var.environment == "live" ? 1 : 0
  name        = "lambda-web-request-rsr-sqs-policy"
  description = "Allow Lambda to read messages from SQS queue"

  policy = templatefile("${path.module}/templates/lambda_rsr_policy.json", {
    queue_arn = aws_sqs_queue.process_submitted_files_queue[0].arn 
  })
}
##########################################
# SQS Queue Policy: Allow S3 to send messages
##########################################
resource "aws_sqs_queue_policy" "process_submitted_files_queue_policy" {
  count = var.environment == "live" ? 1 : 0
  queue_url = aws_sqs_queue.process_submitted_files_queue[0].id

  policy = templatefile("${path.module}/templates/process_submitted_files_sqs_policy.json", {
    queue_arn  = aws_sqs_queue.process_submitted_files_queue[0].arn
    bucket_arn =  "arn:aws:s3:::${var.foi_s3_bucket}"
  })
}

##########################################
# S3 Bucket Notification: trigger SQS on object creation
##########################################
resource "aws_s3_bucket_notification" "submitted_folder_event" {
  count  = var.environment == "live" ? 1 : 0
  bucket = var.foi_s3_bucket
  eventbridge = true

  queue {
    queue_arn     = aws_sqs_queue.process_submitted_files_queue[0].arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "submitted/"
  }

  depends_on = [
    aws_sqs_queue.process_submitted_files_queue,
    aws_sqs_queue_policy.process_submitted_files_queue_policy
  ]
}