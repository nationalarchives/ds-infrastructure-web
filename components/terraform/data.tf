data "aws_caller_identity" "current" {}
data "aws_iam_policy" "org_session_manager_logs_arn" {
    arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}

# certificates
#
data "aws_ssm_parameter" "wildcard_certificate_arn" {
    name = "/infrastructure/certificate-manager/wildcard-certificate-arn"
}

data "aws_ssm_parameter" "us_east_1_wildcard_certificate_arn" {
    name = "/infrastructure/certificate-manager/us-east-1-wildcard-certificate-arn"
}

# networking
#
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

data "aws_ssm_parameter" "private_subnet_2a_id" {
    name = "/infrastructure/network/base/private_subnet_2a_id"
}

data "aws_ssm_parameter" "private_subnet_2a_cidr" {
    name = "/infrastructure/network/base/private_subnet_2a_cidr"
}

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

data "aws_ssm_parameter" "zone_id" {
    name = "/infrastructure/zone_id"
}

# cloudfront
#
data "aws_ssm_parameter" "cf_waf_ip_set" {
    name = "/application/web/frontend/waf/ip_set"
}
# CloudFront custom headers
data "aws_secretsmanager_secret" "web_custom_header" {
    name = "/infrastructure/web/custom_header"
}
data "aws_secretsmanager_secret_version" "web_custom_header" {
    secret_id = data.aws_secretsmanager_secret.web_custom_header.id
}

data "aws_ssm_parameter" "wagtail_efs_media_dns_name" {
    name = "/infrastructure/wagtail-efs/media-dns-name"
}
