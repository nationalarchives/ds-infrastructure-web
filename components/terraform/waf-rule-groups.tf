module "emergency_group" {
    count  = var.waf_rule_group_emergency ? 1 : 0
    source = "./waf-rule-groups/web-emergency"
}

module "external_service_testing" {
    count  = var.waf_rule_group_external_service_testing ? 1 : 0
    source = "./waf-rule-groups/web-external-service-testing"

    x_external_access_key = var.waf_rule_group_external_service_testing == true ? data.aws_ssm_parameter.web_rh_external_service_testing[0].value : ""
}

module "known_ips" {
    count  = var.waf_rule_group_known_ips ? 1 : 0
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
    count = var.waf_rule_group_api_access ? 1 : 0
    source = "./waf-rule-groups/web-api-access"

    unthrottled_api_header_value = var.waf_rule_api_unthrottled_access == true ? data.aws_ssm_parameter.web_rh_api_unthrottled_key[0].value : ""
}

module "targetted_blocks" {
    count  = var.waf_rule_group_targetted_blocks ? 1 : 0
    source = "./waf-rule-groups/web-targetted-blocks"
}

module "rate_limiting" {
    count  = var.waf_rule_group_rate_limiting ? 1 : 0
    source = "./waf-rule-groups/web-rate-limiting"
}
