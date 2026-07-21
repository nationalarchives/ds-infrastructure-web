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

resource "aws_iam_policy" "lambda_web_rsr_policy" {
  name        = "WebrsrCronPolicy"
  description = "Permissions for Web RSR Lambda to interact with EC2, SSM, and invoke Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:GetCommandInvocation"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = "arn:aws:lambda:eu-west-2:${var.account_id}:function:WebrsrCron"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_web_rsr_policy_attach" {
  role       = var.lambda_role_name
  policy_arn = aws_iam_policy.lambda_web_rsr_policy.arn
}

resource "aws_iam_policy" "application_parameter_store_policy" {
  name        = "application-parameter-store-policy"
  description = "Parameter Store and SecureString access for application parameters"

  policy = templatefile("${path.module}/templates/application-parameter-store-policy.json", {
    account_id = var.account_id
  })

  tags = var.tags
}

resource "aws_iam_policy" "web_enrichment_deployment_s3" {
  name        = "web-enrichment-source-s3-policy"
  description = "deployment S3 access for web enrichment"

  policy = templatefile("${path.module}/templates/deployment-source-s3-access.json", {
    deployment_s3_bucket = var.deployment_s3_bucket
    service              = "web"
  })
}


resource "aws_iam_policy" "codedeploy_web_s3_access" {
    name        = "codedeploy-web-s3-access-policy"
    description = "allow code deploy agent access to s3"

    policy = file("${path.root}/shared-templates/codedeploy-s3-policy.json")
}

resource "aws_iam_policy" "codedeploy_web_asg_policy" {
    name        = "codedeploy-web-asg-policy"
    description = "codedeploy access to ASG policy"

    policy = file("${path.root}/shared-templates/codedeploy-asg-policy.json")
}

resource "aws_iam_policy" "codedeploy_web_access_policy" {
    name        = "codedeploy-web-access-policy"
    description = "codedeploy access role policy"

    policy = templatefile("${path.root}/shared-templates/codedeploy-access-policy.json",
        {
            service_policy_arn = aws_iam_policy.codedeploy_web_s3_access.arn
        }
    )
}

resource "aws_iam_policy" "s3_deployment_source_access_policy" {
    name        = "s3-web-deployment-source-access-policy"
    description = "access to source code"

    policy = templatefile("${path.root}/shared-templates/s-devops-s3-access-policy.tftpl",
        {
            bucket_arns = [
                var.s3_deployment_source_arn.value,
            ]
            object_arns = local.object_arns
        }
    )
}

resource "aws_iam_policy" "codedeploy_web_reverse_proxy_s3_access" {
    name        = "codedeploy-web-reverse-proxy-s3-access-policy"
    description = "allow code deploy agent access to s3"

    policy = file("${path.root}/shared-templates/codedeploy-s3-policy.json")
}

resource "aws_iam_policy" "codedeploy_web_reverse_proxy_asg_policy" {
    name        = "codedeploy-web-reverse-proxy-asg-policy"
    description = "codedeploy access to ASG policy"

    policy = file("${path.root}/shared-templates/codedeploy-asg-policy.json")
}

resource "aws_iam_policy" "codedeploy_web_reverse_proxy_access_policy" {
    name        = "codedeploy-web-reverse-proxy-access-policy"
    description = "codedeploy access role policy"

    policy = templatefile("${path.root}/shared-templates/codedeploy-access-policy.json",
        {
            service_policy_arn = aws_iam_policy.codedeploy_web_reverse_proxy_s3_access.arn
        }
    )
}

resource "aws_iam_policy" "s3_deployment_source_static_content_read" {
    name        = "s3-deployment-source-static-content-read"
    description = "read access to the ds-<env>-deployment-source/static_content folder"

    policy = templatefile("${path.root}/shared-templates/s3_constrained_read_access.tftpl",
        {
            s3_bucket_arn = var.s3_deployment_source_arn.value
            prefix_list   = ["","static_content/","static_content/accessions/"]
        }
    )
}

resource "aws_iam_policy" "ses_access" {
  name        = "web-request-service-record-ses-access-policy"
  description = "ses access for web-request-service-record"
  policy      = data.aws_iam_policy_document.ses_access.json
}

resource "aws_iam_policy" "ec2_access" {
  name        = "web-request-service-record-ec2-access-policy"
  description = "ec2 access for web-request-service-record"
  policy      = data.aws_iam_policy_document.ec2_access.json
}


resource "aws_iam_policy" "web_bulkdownload_s3_access" {
  name        = "web-bulkdownload-s3-access"
  description = "Allow web bulkdownload EC2 instances access to downloads S3 bucket"

  policy = templatefile(
    "${path.module}/templates/web-bulkdownload-s3-access.json",
    {
      environment = var.environment
    }
  )
}

##########################################
# IAM Policy: Web Forms SES Access
##########################################
resource "aws_iam_policy" "web_forms_ses_policy" {
  name        = "web-forms-ses-policy"
  description = "Allow web forms service to send emails through Amazon SES"

  policy = templatefile("${path.module}/templates/web-forms-ses-policy.json", {
    account_id = var.account_id
  })
}

##########################################
# IAM Policy: Wagtail Cron Execution
##########################################
resource "aws_iam_policy" "lambda_wagtail_cron_trigger_policy" {
  name        = "WagtailCronTriggerLambdaPolicy"
  description = "Permissions for Wagtail Cron Trigger Lambda"

  policy = templatefile(
    "${path.module}/templates/wagtail-cron-trigger-policy.json",
    {
      account_id = var.account_id
    }
  )
}

##########################################
# IAM Policy: Lambda SSM Execution
##########################################
resource "aws_iam_policy" "lambda_ssm_execution" {
  name        = "lambda-ssm-execution-policy"
  description = "Least-privilege permissions for Lambda to use EC2, SSM and CloudWatch Logs"

  policy = file(
    "${path.root}/iam/policies/templates/lambda-ssm-execution-policy.json"
  )
}
