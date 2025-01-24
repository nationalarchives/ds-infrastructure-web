variable "web_acl_default_action_allow" {}

variable "web_acl_requests_in_5_minutes" {}
variable "web_acl_shield_advanced_active" {}
variable "web_acl_amazon_ip_reputation_list" {}
variable "web_acl_managed_rules_linux_rule_set" {}
variable "web_acl_managed_rules_php_rule_set" {}

module "waf" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }

    source = "./waf"

    site_ips = split(",", data.aws_ssm_parameter.cf_waf_ip_set.value)
    tags     = local.tags

    web_acl_default_action_allow         = var.web_acl_default_action_allow
    web_acl_requests_in_5_minutes        = var.web_acl_requests_in_5_minutes
    web_acl_shield_advanced_active       = var.web_acl_shield_advanced_active
    web_acl_amazon_ip_reputation_list    = var.web_acl_amazon_ip_reputation_list
    web_acl_managed_rules_linux_rule_set = var.web_acl_managed_rules_linux_rule_set
    web_acl_managed_rules_php_rule_set   = var.web_acl_managed_rules_php_rule_set
}
