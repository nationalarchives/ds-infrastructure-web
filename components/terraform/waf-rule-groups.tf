import {
  to = module.emergency_group[0].aws_wafv2_rule_group.web_emergency_rg
  id = "df52d9dd-ec4a-4c18-8b25-f414aa0452fc/web-emergency-rg/CLOUDFRONT"
    region = "us-east-1"
}

module "emergency_group" {
    count  = var.waf_rule_group_emergency == true ? 1 : 0
    source = "./waf-rule-groups/web-emergency"
}

module "external_service_testing" {
    count  = var.waf_rule_group_external_service_testing == true ? 1 : 0
    source = "./waf-rule-groups/web-external-service-testing"

    x_external_access_key = var.waf_rule_group_external_service_testing == true ? data.aws_ssm_parameter.web_rh_external_service_testing[0].value : ""
}

module "known_ips" {
    count  = var.waf_rule_group_known_ips == true ? 1 : 0
    source = "./waf-rule-groups/web-known-ips"

    environment  = var.environment
    allow_action = var.waf_rule_default_action_allow
    # changes to the different IP sets should be done using the CI/CD piplines in GitHub
    known_ipset_arn               = module.waf.access_ip_set_arn
    exception_ipset_arn           = module.waf.exception_ip_set_arn
    wagtail_admin_ipset_arn       = module.waf.wagtail_admin_ip_set_arn
    wp_admin_ipset_arn            = module.waf.wp_admin_ip_set_arn
    torchbox_seo_audit_ipset_arn = module.waf.torchbox_seo_audit_ip_set_arn
}

module "api_access" {
    count = var.waf_rule_group_api_access == true ? 1 : 0
    source = "./waf-rule-groups/web-api-access"

    api_access_header_value = var.waf_rule_group_api_access == true ? data.aws_ssm_parameter.web_rh_api_access_key[0].value : ""
}

module "targetted_blocks" {
    count  = var.waf_rule_group_targetted_blocks == true ? 1 : 0
    source = "./waf-rule-groups/web-targetted-blocks"
}

module "rate_limiting" {
    count  = var.waf_rule_group_rate_limiting == true ? 1 : 0
    source = "./waf-rule-groups/web-rate-limiting"
}
