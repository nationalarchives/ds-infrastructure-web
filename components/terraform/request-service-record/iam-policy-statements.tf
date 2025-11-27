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
            "arn:aws:ssm:eu-west-2:${var.account_id}:parameter/application/web/requestservicerecord",
        ]
    }
}

data "aws_iam_policy_document" "ses_access" {
    statement {
        sid = "ses_sendemail"
        actions = [
            "ses:SendEmail",
        ]
        resources = [
            var.ses_nationalarchives_gov_uk_domain_arn
        ]
    }
}
