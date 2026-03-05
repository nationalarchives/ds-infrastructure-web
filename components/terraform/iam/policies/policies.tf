resource "aws_iam_policy" "deployment_s3" {
    name        = "web-deployment-source-s3-policy"
    description = "deployment S3 access for web"

    policy = templatefile("${path.module}/templates/deployment-source-s3-access.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = var.service
    })
}

# web-docker-deployment
#
resource "aws_iam_policy" "lambda_web_docker_deployment_policy" {
    name        = "lambda-web-docker-deployment-policy"
    description = "receive instance data and manipulate status"

    policy = templatefile("${path.module}/templates/lambda-web-docker-deployment-policy.json", {
        account_id = var.account_id
    })
}

# iam policy for parameter store

resource "aws_iam_policy" "web_ssm" {
   name        = "web-frontend-ssm-policy"
   description = "SSM access to web frontend server"
   policy = templatefile("${path.module}/templates/instance-ssm-policy.json", {
       account_id = var.account_id
   })
}

resource "aws_iam_policy" "web_request_s3_copy_policy" {
  name        = "web-request-s3-copy-policy"
  description = "Policy to copy objects from holding to submitted"

  policy = templatefile("${path.module}/templates/foi-s3-copy-policy.json", {
    foi_s3_bucket = var.foi_s3_bucket
  })
}
