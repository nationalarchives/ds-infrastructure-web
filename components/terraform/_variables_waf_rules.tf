variable "waf_rule_group_emergency" {
    description = "create rule group"
    default     = false
}

variable "waf_rule_default_action_allow" {}
variable "site_ips" {}
variable "waf_tags" {}
variable "waf_rule_shield_advanced_active" {
    default = false
}

variable "waf_rule_api_access" {
    description = "allow access to API endpoints by matching a specific URI path pattern"
    default     = false
}
variable "waf_rule_api_access_priority" {
    description = "priority of the API access rule"
    default     = 0
}

variable "waf_rule_external_application_testing" {
    description = "allow external application testing by matching a specific header value"
    default     = false
}
variable "waf_rule_external_application_testing_priority" {
    description = "priority of the external application testing rule"
    default     = 0
}

variable "waf_rule_api_unthrottled_access" {
    description = "allow api unthrottled access by matching a specific header value"
    default     = false
}
variable "waf_rule_api_unthrottled_access_priority" {
    description = "priority of the api unthrottled access rule"
    default     = 0
}

variable "waf_rule_geo_restrictions" {
    description = "block access from specific countries"
    default     = false
}
variable "waf_rule_geo_restriction_priority" {
    description = "priority of the geo restriction rule"
    default     = 0
}
variable "waf_rule_geo_restriction_action" {
    description = "action to take when a request matches the geo restriction rule"
    type        = string
    default     = "block"
}
variable "waf_rule_geo_restriction_countries" {
    description = "list of country codes to block access from"
    type = list(string)
    default = []
}

variable "waf_rule_ip_address_access" {
    description = "allow or block access based on IP addresses in an IP set"
    default     = false
}
variable "waf_rule_ip_address_access_priority" {
    description = "priority of the IP address access rule"
    default     = 0
}

variable "waf_rule_rate_limiting" {
    description = "limit the number of requests from a single IP address over a specified time period"
    default     = false
}
variable "waf_rule_rate_limiting_priority" {
    description = "priority of the rate limiting rule"
    default     = 0
}
variable "waf_rule_rate_limiting_limit" {
    description = "the maximum number of requests allowed in the specified evaluation window before the rule action"
    default     = 0
}
variable "waf_rule_rate_limiting_aggregate_key_type" {
    description = "the method used to aggregate the request counts. Valid values are: IP, FORWARDED_IP, or CUSTOM_KEY."
    default     = "IP"
}
variable "waf_rule_rate_limiting_evaluation_window_sec" {
    description = "the time period, in seconds, over which the specified rate limit applies. Valid values are between 1 and 3600 seconds."
    default     = 300
}
variable "waf_rule_block_bytespider" {
    description = "block requests from the ByteSpider bot by matching a specific label"
    default     = false
}
variable "waf_rule_block_bytespider_priority" {
    description = "priority of the ByteSpider blocking rule"
    default     = 0
}
variable "waf_rule_mozlila_digitalocean" {
    description = "block requests from the Mozilla DigitalOcean bot by matching a specific label"
    default     = false
}
variable "waf_rule_mozlila_digitalocean_priority" {
    description = "priority of the Mozilla DigitalOcean blocking rule"
    default     = 0
}

#
# AWS managed rule ets
variable "waf_rule_aws_managed_bot_control_rule_set" {
    description = "enable the AWS Managed Bot Control Rule Set to protect against common bots and scrapers, with optional configuration for inspection level and rule action overrides"
    default     = false
}
variable "waf_rule_aws_managed_bot_control_rule_set_priority" {
    description = "priority of the AWS Managed Bot Control Rule Set"
    default     = 0
}
variable "waf_rule_aws_managed_bot_control_rule_set_overwrite_action" {
    description = "Action to use instead of the AWS Managed Rule Group's default action. Valid values are: none, count."
    default     = "none"
}
variable "waf_rule_aws_managed_bot_control_rule_set_inspection_level" {
    description = "Inspection level for the AWS Managed Bot Control Rule Set. Valid values are: COMMON, EXTENDED, or TARGETED."
    default     = "COMMON"
}
variable "waf_rule_aws_managed_bot_control_rule_set_action_overrides" {
    description = "List of rule action overrides for specific rules within the AWS Managed Bot Control Rule"
    type = list(object({
        name          = string
        action_to_use = string
    }))
    default = []
}

variable "waf_rule_aws_managed_amazon_ip_reputation_list" {
    description = "enable the AWS Managed Amazon IP Reputation List to block requests from known malicious IP addresses, with optional configuration for rule action overrides"
    default     = false
}
variable "waf_rule_aws_managed_amazon_ip_reputation_list_priority" {
    description = "priority of the AWS Managed Amazon IP Reputation List"
    default     = 0
}
variable "waf_rule_aws_managed_ip_reputation_list_overwrite_action" {
    description = "Action to use instead of the AWS Managed Rule Group's default action. Valid values are: none, count."
    default     = "none"
}
variable "waf_rule_aws_managed_ip_reputation_list_action_overrides" {
    description = "List of rule action overrides for specific rules within the AWS Managed Amazon IP Reputation List"
    type = list(object({
        name          = string
        action_to_use = string
    }))
    default = []
}

variable "waf_rule_managed_rules_linux_rule_set" {
    description = "enable the AWS Managed Linux Rule Set to protect against common Linux-based vulnerabilities, with optional configuration for rule action overrides"
    default     = false
}
variable "waf_rule_managed_rules_linux_rule_set_priority" {
    description = "priority of the AWS Managed Linux Rule Set"
    default     = 0
}
variable "waf_rule_managed_rules_linux_rule_set_overwrite_action" {
    description = "Action to use instead of the AWS Managed Rule Group's default action. Valid values are: none, count."
    default     = "none"
}
variable "waf_rule_managed_rules_linux_rule_set_action_overrides" {
    description = "List of rule action overrides for specific rules within the AWS Managed Linux Rule Set"
    type = list(object({
        name          = string
        action_to_use = string
    }))
    default = []
}
variable "waf_rule_managed_rules_known_bad_inputs" {
    description = "enable the AWS Managed Rule Set for Known Bad Inputs to block requests that contain common attack patterns, with optional configuration for rule action overrides"
    default     = false
}
variable "waf_rule_managed_rules_known_bad_inputs_priority" {
    description = "priority of the AWS Managed Rule Set for Known Bad Inputs"
    default     = 0
}
variable "waf_rule_managed_rules_known_bad_inputs_overwrite_action" {
    description = "Action to use instead of the AWS Managed Rule Group's default action. Valid values are: none, count."
    default     = "none"
}
variable "waf_rule_managed_rules_known_bad_inputs_action_overrides" {
    description = "List of rule action overrides for specific rules within the AWS Managed Rule Set for Known Bad Inputs"
    type = list(object({
        name          = string
        action_to_use = string
    }))
    default = []
}
variable "waf_rule_managed_rules_wordpress_rule_set" {
    description = "enable the AWS Managed Rule Set for WordPress to protect against common WordPress vulnerabilities, with optional configuration for rule action overrides"
    default     = false
}
variable "waf_rule_managed_rules_wordpress_rule_set_priority" {
    description = "priority of the AWS Managed Rule Set for WordPress"
    default     = 0
}
variable "waf_rule_managed_rules_wordpress_rule_set_overwrite_action" {
    description = "Action to use instead of the AWS Managed Rule Group's default action. Valid values are: none, count."
    default     = "none"
}
variable "waf_rule_managed_rules_wordpress_rule_set_action_overrides" {
    description = "List of rule action overrides for specific rules within the AWS Managed Rule Set for WordPress"
    type = list(object({
        name          = string
        action_to_use = string
    }))
    default = []
}
variable "waf_rule_managed_rules_sqli_rule_set" {
    description = "priority of the AWS Managed Rule Set for SQL Injection"
    default     = 0
}
variable "waf_rule_managed_rules_sqli_rule_set_priority" {
    description = "priority of the AWS Managed Rule Set for SQL Injection"
    default     = 0
}
variable "waf_rule_managed_rules_sqli_rule_set_overwrite_action" {
    description = "Action to use instead of the AWS Managed Rule Group's default action. Valid values are: none, count."
    default     = "none"
}
variable "waf_rule_managed_rules_sqli_rule_set_action_overrides" {
    description = "List of rule action overrides for specific rules within the AWS Managed Rule Set for SQL Injection"
    type = list(object({
        name          = string
        action_to_use = string
    }))
    default = []
}
variable "waf_rule_exclude_from_sql_injection_managed_rule" {
    description = "exclude specific rules from the AWS Managed SQL Injection Rule Set to prevent false positives, with optional configuration for rule action overrides"
    default     = false
}
variable "waf_rule_exclude_from_sql_injection_managed_rule_priority" {
    description = "priority of the rule for excluding specific rules from the AWS Managed SQL Injection Rule Set"
    default     = 0
}

variable "waf_rule_managed_rules_php_rule_set" {
    description = "enable the AWS Managed Rule Set for PHP to protect against common PHP vulnerabilities, with optional configuration for rule action overrides"
    default     = false
}
variable "waf_rule_managed_rules_php_rule_set_priority" {
    description = "priority of the AWS Managed Rule Set for PHP"
    default     = 0
}
variable "waf_rule_managed_rules_php_rule_set_overwrite_action" {
    description = "Action to use instead of the AWS Managed Rule Group's default action. Valid values are: none, count."
    default     = "none"
}
variable "waf_rule_managed_rules_php_rule_set_action_overrides" {
    description = "List of rule action overrides for specific rules within the AWS Managed Rule Set for PHP"
    type = list(object({
        name          = string
        action_to_use = string
    }))
    default = []
}
variable "waf_rule_php_rule_set_wagtail_filter" {
    description = "List of scope down rules for the AWS Managed Rule Set for PHP"
    type = object({
        name                              = string
        priority                          = number
        positional_constraint             = string
        search_string                     = string
        field_to_match_single_header_name = string
    })
    default = {
        name                              = "PHPRuleSet_label_excl_wagtail"
        priority                          = 100000
        positional_constraint             = "EXACTLY"
        search_string                     = "wagtail.nationalarchives.gov.uk"
        field_to_match_single_header_name = "host"
    }
}
