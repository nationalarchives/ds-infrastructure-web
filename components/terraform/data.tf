# networking
# required
data "aws_ssm_parameter" "vpc_id" {               
    name = "/infrastructure/network/base/vpc_id"
}

data "aws_ssm_parameter" "vpc_cidr" {
    name = "/infrastructure/network/base/vpc_cidr"
}

data "aws_ssm_parameter" "public_subnet_2a_id" {
    name = "/infrastructure/network/base/public_subnet_2a_id"
}

data "aws_ssm_parameter" "public_subnet_2a_cidr" {
    name = "/infrastructure/network/base/public_subnet_2a_cidr"
}

data "aws_ssm_parameter" "public_subnet_2b_id" {
    name = "/infrastructure/network/base/public_subnet_2b_id"
}

data "aws_ssm_parameter" "public_subnet_2b_cidr" {
    name = "/infrastructure/network/base/public_subnet_2b_cidr"
}
#required
data "aws_ssm_parameter" "private_subnet_2a_id" {
    name = "/infrastructure/network/base/private_subnet_2a_id"
}

data "aws_ssm_parameter" "private_subnet_2a_cidr" {
    name = "/infrastructure/network/base/private_subnet_2a_cidr"
}
#required
data "aws_ssm_parameter" "private_subnet_2b_id" {
    name = "/infrastructure/network/base/private_subnet_2b_id"
}

data "aws_ssm_parameter" "private_subnet_2b_cidr" {
    name = "/infrastructure/network/base/private_subnet_2b_cidr"
}

data "aws_ssm_parameter" "private_db_subnet_2a_id" {
    name = "/infrastructure/network/base/private_db_subnet_2a_id"
}

data "aws_ssm_parameter" "private_db_subnet_2a_cidr" {
    name = "/infrastructure/network/base/private_db_subnet_2a_cidr"
}

data "aws_ssm_parameter" "private_db_subnet_2b_id" {
    name = "/infrastructure/network/base/private_db_subnet_2b_id"
}

data "aws_ssm_parameter" "private_db_subnet_2b_cidr" {
    name = "/infrastructure/network/base/private_db_subnet_2b_cidr"
}

data "aws_ssm_parameter" "client_vpn_cidr" {
    name = "/infrastructure/client_vpn_cidr"
}

# amis
#

data "aws_ami" "web_dw_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "website-wp-primer-2024-07-16 16-08-13"
        ]
    }

    filter {
        name   = "virtualization-type"
        values = [
            "hvm"
        ]
    }

    owners = [
        data.aws_caller_identity.current.account_id,
        "amazon"
    ]
}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "zone_id" {
    name = "/infrastructure/zone_id"
}

data "aws_ssm_parameter" "sns_slack_alert" {
    name = "/infrastructure/sns_slack_alert_arn"
}

# certificates
#
data "aws_ssm_parameter" "wildcard_certificate_arn" {
    name = "/infrastructure/certificate-manager/wildcard-certificate-arn"
}

data "aws_ssm_parameter" "us_east_1_wildcard_certificate_arn" {
    name = "/infrastructure/certificate-manager/us-east-1-wildcard-certificate-arn"
}

# DB Security Group
#
data "aws_ssm_parameter" "web_db_sg_id" {
    name = "/infrastructure/web_db_sg_id"
}

# codedeploy
# ----------------
data "aws_ssm_parameter" "s3_deployment_source_arn" {
    name = "/infrastructure/s3/deployment_source_arn"
}

# cloudfront
#
data "aws_ssm_parameter" "cf_waf_ip_set" {
    name = "/application/beta/waf/ip_set"
}

# CloudFront custom headers
data "aws_secretsmanager_secret" "beta_custom_header" {
    name = "/infrastructure/beta/custom_header"
}
data "aws_secretsmanager_secret_version" "beta_custom_header" {
    secret_id = data.aws_secretsmanager_secret.beta_custom_header.id
}
