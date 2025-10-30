resource "aws_iam_policy" "request_service_record_deployment_s3" {
    name        = "request-service-record-source-s3-policy"
    description = "deployment S3 access for mod-foi frontend"

    policy = templatefile("${path.module}/templates/deployment-source-s3-access.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = "request-service-record"
    })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
    role       = var.role_name
    policy_arn = aws_iam_policy.request_service_record_deployment_s3.arn
}
