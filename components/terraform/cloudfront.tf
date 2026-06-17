module "cf_custom_cache_policies" {
    source = "./cloudfront-cache-policies"

    default_ttl = var.cf_default_ttl
    max_ttl = var.cf_max_ttl
    min_ttl = var.cf_min_ttl

    help_with_your_research_default_ttl = var.help_with_your_research_default_ttl
    help_with_your_research_max_ttl = var.help_with_your_research_max_ttl
    help_with_your_research_min_ttl = var.help_with_your_research_min_ttl

    web_5_minute_update_default_ttl = var.web_5_minute_update_default_ttl
    web_5_minute_update_max_ttl = var.web_5_minute_update_max_ttl
    web_5_minute_update_min_ttl = var.web_5_minute_update_min_ttl
}

module "cloudfront" {
    source = "./cloudfront"

    wildcard_certificate_arn = data.aws_ssm_parameter.us_east_1_wildcard_certificate_arn.value
    web_waf_info         = module.waf.web_waf_info

    web_monthly_update_policy_id  = module.cf_custom_cache_policies.web_monthly_update_id
    web_weekly_update_policy_id   = module.cf_custom_cache_policies.web_weekly_update_id
    web_5_minute_update_policy_id = module.cf_custom_cache_policies.web_5_minute_update_id

    web_reverse_proxy_lb_dns_name = module.web_reverse_proxy.web_reverse_proxy_lb_dns_name

    custom_header_name  = jsondecode(data.aws_secretsmanager_secret_version.web_custom_header.secret_string)["header_name"]
    custom_header_value = jsondecode(data.aws_secretsmanager_secret_version.web_custom_header.secret_string)["header_value"]

    account      = var.account
    environment  = var.environment
    default_tags = var.default_tags
}
