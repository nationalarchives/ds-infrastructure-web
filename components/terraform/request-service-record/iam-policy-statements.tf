data "aws_iam_policy_document" "ec2_access" {
    statement {
        sid = "deploymentBucketAccess"
        actions = [
            "s3:ListBucket",
            "s3:GetObject",
        ]
        resources = [
            "arn:aws:s3:::${var.deployment_s3_bucket}",
            "arn:aws:s3:::${var.deployment_s3_bucket}/${local.service_name}/*",
        ]
    }

    statement {
        sid = "ssmAccess"
        actions = [
            "ssm:GetParametersByPath",
        ]
        resources = [
            "arn:aws:ssm:::parameter/application/web/requestservicerecord",
        ]
    }
}
