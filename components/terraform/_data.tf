data "aws_caller_identity" "current" {}
data "aws_iam_policy" "org_session_manager_logs" {
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
data "aws_ssm_parameter" "admin_subdomain_certificate_arn" {
    name = "/infrastructure/certificate-manager/website-admin-subdomain-certificate-arn"
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

data "aws_ssm_parameter" "ses_nationalarchives_gov_uk_domain_arn" {
    name = "/infrastructure/ses/nationalarchives_gov_uk/domain-identifier-arn"
}

data "aws_ssm_parameter" "foi1939_register_write_policy_arn" {
    name = "/infrastructure/s3/policies/write/foi1939_register_arn"
}

# ------------------------------------------------------------------------------
# web waf rule values for request headers
# - they need to be used by defining the condition in locals
# ------------------------------------------------------------------------------
data "aws_ssm_parameter" "web_rh_external_service_testing" {
    count = var.waf_rule_group_external_service_testing == true ? 1 : 0
    name = "/infrastructure/web/waf/request-header/external-service-testing"
}
data "aws_ssm_parameter" "web_rh_api_access_key" {
    count = var.waf_rule_group_api_access == true ? 1 : 0
    name = "/infrastructure/web/waf/request-header/api-access-key"
}

# codedeploy
# ----------------
data "aws_ssm_parameter" "s3_deployment_source_arn" {
    name = "/infrastructure/s3/deployment_source_arn"
}
