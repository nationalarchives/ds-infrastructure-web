module "waf" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    source = "./waf"

    site_ips           = var.site_ips
    exception_site_ips = var.exception_site_ips

    waf_rule_default_action_allow   = var.waf_rule_default_action_allow
    waf_rule_shield_advanced_active = var.waf_rule_shield_advanced_active

    environment = var.environment
    tags        = var.waf_tags
}

#
# Custom Rules
# ------------
module "waf_rule_api_access" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_api_access == true ? 1 : 0
    source = "./waf-rules/api-access"

    web_acl_arn = module.waf.web_acl_arn
    priority    = var.waf_rule_api_access_priority
}

module "external_application_testing" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_external_application_testing == true ? 1 : 0
    source = "./waf-rules/external-application-testing"

    web_acl_arn  = module.waf.web_acl_arn
    header_value = var.waf_rule_external_application_testing == true ? data.aws_ssm_parameter.web_rh_external_application_testing[0].value : ""
    priority     = var.waf_rule_external_application_testing_priority
}
module "waf_rule_api_unthrottled_access" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_api_unthrottled_access == true ? 1 : 0
    source = "./waf-rules/api-unthrottled-access"

    web_acl_arn  = module.waf.web_acl_arn
    header_value = var.waf_rule_api_unthrottled_access == true ?
        data.aws_ssm_parameter.web_rh_api_unthrottled_key[0].value : ""
    priority     = var.waf_rule_api_unthrottled_access_priority
}
module "waf_rule_geo_restriction" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_geo_restrictions == true ? 1 : 0
    source = "./waf-rules/geo-restrictions"

    web_acl_arn = module.waf.web_acl_arn
    priority    = var.waf_rule_geo_restriction_priority
    action      = "${var.waf_rule_geo_restriction_action}"
    countries   = var.waf_rule_geo_restriction_countries
}
module "waf_rule_ip_address_access" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_ip_address_access == true ? 1 : 0
    source = "./waf-rules/ip-address-access"

    web_acl_arn                   = module.waf.web_acl_arn
    priority                      = var.waf_rule_ip_address_access_priority
    waf_rule_default_action_allow = var.waf_rule_default_action_allow
    access_ip_set_arn             = module.waf.access_ip_set_arn
}
module "waf_rule_rate_limiting" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_rate_limiting == true ? 1 : 0
    source = "./waf-rules/rate-limiting"

    web_acl_arn           = module.waf.web_acl_arn
    priority              = var.waf_rule_rate_limiting_priority
    limit                 = var.waf_rule_rate_limiting_limit
    aggregate_key_type    = var.waf_rule_rate_limiting_aggregate_key_type
    evaluation_window_sec = var.waf_rule_rate_limiting_evaluation_window_sec
}
module "waf_rule_block_bytespider" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_block_bytespider == true ? 1 : 0
    source = "./waf-rules/block_bytespider"

    web_acl_arn = module.waf.web_acl_arn
    priority    = var.waf_rule_block_bytespider_priority
}
module "waf_rule_mozlila_digitalocean" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_mozlila_digitalocean == true ? 1 : 0
    source = "./waf-rules/mozlila-digitalocean"

    web_acl_arn = module.waf.web_acl_arn
    priority    = var.waf_rule_mozlila_digitalocean_priority
}

#
# AWS Managed Rules
# -----------------
module "waf_rule_aws_managed_bot_control_rule_set" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_aws_managed_bot_control_rule_set == true ? 1 : 0
    source = "./waf-rules/aws-managed/BotControlRuleSet"

    web_acl_arn      = module.waf.web_acl_arn
    priority         = var.waf_rule_aws_managed_bot_control_rule_set_priority
    overwrite_action = var.waf_rule_aws_managed_bot_control_rule_set_overwrite_action
    inspection_level = var.waf_rule_aws_managed_bot_control_rule_set_inspection_level
    action_overrides = var.waf_rule_aws_managed_bot_control_rule_set_action_overrides
}
module "waf_rule_aws_managed_amazon_ip_reputation_list" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_aws_managed_amazon_ip_reputation_list == true ? 1 : 0
    source = "./waf-rules/aws-managed/AmazonIpReputationList"

    web_acl_arn      = module.waf.web_acl_arn
    priority         = var.waf_rule_aws_managed_amazon_ip_reputation_list_priority
    overwrite_action = var.waf_rule_aws_managed_ip_reputation_list_overwrite_action
    action_overrides = var.waf_rule_aws_managed_ip_reputation_list_action_overrides
}
module "waf_rule_aws_managed_linux_rule_set" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_managed_rules_linux_rule_set == true ? 1 : 0
    source = "./waf-rules/aws-managed/LinuxRuleSet"

    web_acl_arn      = module.waf.web_acl_arn
    priority         = var.waf_rule_managed_rules_linux_rule_set_priority
    overwrite_action = var.waf_rule_managed_rules_linux_rule_set_overwrite_action
    action_overrides = var.waf_rule_managed_rules_linux_rule_set_action_overrides
}
module "waf_rule_aws_managed_know_bad_input" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_managed_rules_known_bad_inputs == true ? 1 : 0
    source = "./waf-rules/aws-managed/KnownBadInputsRuleSet"

    web_acl_arn      = module.waf.web_acl_arn
    priority         = var.waf_rule_managed_rules_known_bad_inputs_priority
    overwrite_action = var.waf_rule_managed_rules_known_bad_inputs_overwrite_action
    action_overrides = var.waf_rule_managed_rules_known_bad_inputs_action_overrides
}
module "waf_rule_aws_managed_wordpress_rule_set" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_managed_rules_wordpress_rule_set == true ? 1 : 0
    source = "./waf-rules/aws-managed/WordPressRuleSet"

    web_acl_arn      = module.waf.web_acl_arn
    priority         = var.waf_rule_managed_rules_wordpress_rule_set_priority
    overwrite_action = var.waf_rule_managed_rules_wordpress_rule_set_overwrite_action
    action_overrides = var.waf_rule_managed_rules_wordpress_rule_set_action_overrides

}
module "exclude_from_sql_injection_managed_rule" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_exclude_from_sql_injection_managed_rule == true ? 1 : 0
    source = "./waf-rules/exclude-from-sql-injection-managed-rule"

    web_acl_arn = module.waf.web_acl_arn
    priority    = var.waf_rule_exclude_from_sql_injection_managed_rule_priority
}
module "waf_rule_managed_rules_sqli_rule_set" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_managed_rules_sqli_rule_set == true ? 1 : 0
    source = "./waf-rules/aws-managed/SQLiRuleSet"

    web_acl_arn      = module.waf.web_acl_arn
    priority         = var.waf_rule_managed_rules_sqli_rule_set_priority
    overwrite_action = var.waf_rule_managed_rules_sqli_rule_set_overwrite_action
    action_overrides = var.waf_rule_managed_rules_sqli_rule_set_action_overrides

}
module "waf_rule_managered_rules_php_rule_set" {
    providers = {
        aws.aws-cf-waf = aws.aws-cf-waf
    }
    count  = var.waf_rule_managed_rules_php_rule_set == true ? 1 : 0
    source = "./waf-rules/aws-managed/PHPRuleSet"

    web_acl_arn      = module.waf.web_acl_arn
    priority         = var.waf_rule_managed_rules_php_rule_set_priority
    overwrite_action = var.waf_rule_managed_rules_php_rule_set_overwrite_action
    action_overrides = var.waf_rule_managed_rules_php_rule_set_action_overrides

    wagtail_filter_values = var.waf_rule_php_rule_set_wagtail_filter
}
