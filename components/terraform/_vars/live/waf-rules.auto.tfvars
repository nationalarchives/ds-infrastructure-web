waf_rule_external_application_testing          = true
waf_rule_external_application_testing_priority = 100

waf_rule_api_unthrottled_access          = true
waf_rule_api_unthrottled_access_priority = 200

waf_rule_geo_restrictions         = true
waf_rule_geo_restriction_priority = 300
waf_rule_geo_restriction_action   = "count"
waf_rule_geo_restriction_countries = ["BR", "RU", "CN"]

waf_rule_ip_address_access          = false
waf_rule_ip_address_access_priority = 400

waf_rule_rate_limiting                       = true
waf_rule_rate_limiting_priority              = 500
waf_rule_rate_limiting_limit                 = 2000
waf_rule_rate_limiting_aggregate_key_type    = "IP"
waf_rule_rate_limiting_evaluation_window_sec = 300

waf_rule_block_bytespider          = true
waf_rule_block_bytespider_priority = 600

waf_rule_mozlila_digitalocean          = true
waf_rule_mozlila_digitalocean_priority = 700

waf_rule_aws_managed_bot_control_rule_set                  = true
waf_rule_aws_managed_bot_control_rule_set_priority         = 800
waf_rule_aws_managed_bot_control_rule_set_overwrite_action = "none"
waf_rule_aws_managed_bot_control_rule_set_inspection_level = "COMMON"
waf_rule_aws_managed_bot_control_rule_set_action_overrides = [
    {
        name          = "AWSManagedRulesBotControlRuleSet"
        action_to_use = "count"
    },
    {
        name          = "CategoryAdvertising"
        action_to_use = "count"
    },
    {
        name          = "CategoryArchiver"
        action_to_use = "count"
    },
    {
        name          = "CategoryContentFetcher"
        action_to_use = "count"
    },
    {
        name          = "CategoryEmailClient"
        action_to_use = "count"
    },
    {
        name          = "CategoryHttpLibrary"
        action_to_use = "count"
    },
    {
        name          = "CategoryLinkChecker"
        action_to_use = "count"
    },
    {
        name          = "CategoryMiscellaneous"
        action_to_use = "count"
    },
    {
        name          = "CategoryMonitoring"
        action_to_use = "count"
    },
    {
        name          = "CategoryScrapingFramework"
        action_to_use = "count"
    },
    {
        name          = "CategorySearchEngine"
        action_to_use = "count"
    },
    {
        name          = "CategorySecurity"
        action_to_use = "count"
    },
    {
        name          = "CategorySeo"
        action_to_use = "count"
    },
    {
        name          = "CategorySocialMedia"
        action_to_use = "count"
    },
    {
        name          = "CateoryAI"
        action_to_use = "block"
    },
    {
        name          = "SignalAutomatedBrowser"
        action_to_use = "count"
    },
    {
        name          = "SignalKnownBotDataCenter"
        action_to_use = "count"
    },
    {
        name          = "SignalNonBrowserUserAgent"
        action_to_use = "count"
    },
    {
        name          = "TGT_VolumetricIpTokenAbsent"
        action_to_use = "challenge"
    },
    {
        name          = "TGT_VolumetricSession"
        action_to_use = "captcha"
    },
    {
        name          = "TGT_SignalAutomatedBrowser"
        action_to_use = "captcha"
    },
    {
        name          = "TGT_SignalBrowserInconsistency"
        action_to_use = "captcha"
    },
    {
        name          = "TGT_TokenReuseIp"
        action_to_use = "count"
    },
    {
        name          = "TGT_ML_CoordinatedActivityMedium"
        action_to_use = "count"
    },
    {
        name          = "CaTGT_ML_CoordinatedActivityHighteoryAI"
        action_to_use = "count"
    },
]

waf_rule_aws_managed_amazon_ip_reputation_list           = true
waf_rule_aws_managed_amazon_ip_reputation_list_priority  = 900
waf_rule_aws_managed_ip_reputation_list_overwrite_action = "none"
waf_rule_aws_managed_ip_reputation_list_action_overrides = [
    {
        name          = "AWSManagedIPReputationList"
        action_to_use = "block"
    },
    {
        name          = "AWSManagedReconnaissanceList"
        action_to_use = "block"
    },
    {
        name          = "AWSManagedIPDDoSList"
        action_to_use = "count"
    },
]

waf_rule_managed_rules_linux_rule_set                  = true
waf_rule_managed_rules_linux_rule_set_priority         = 1000
waf_rule_managed_rules_linux_rule_set_overwrite_action = "none"
waf_rule_managed_rules_linux_rule_set_action_overrides = [
    {
        name          = "LFI_URIPATH"
        action_to_use = "block"
    },
    {
        name          = "LFI_QUERYSTRING"
        action_to_use = "block"
    },
    {
        name          = "LFI_HEADER"
        action_to_use = "block"
    },
]

waf_rule_managed_rules_known_bad_inputs                  = true
waf_rule_managed_rules_known_bad_inputs_priority         = 1100
waf_rule_managed_rules_known_bad_inputs_overwrite_action = "none"
waf_rule_managed_rules_known_bad_inputs_action_overrides = [
    {
        name          = "avaDeserializationRCE_BODY"
        action_to_use = "block"
    },
    {
        name          = "JavaDeserializationRCE_URIPATH"
        action_to_use = "block"
    },
    {
        name          = "JavaDeserializationRCE_QUERYSTRING"
        action_to_use = "block"
    },
    {
        name          = "JavaDeserializationRCE_HEADER"
        action_to_use = "block"
    },
    {
        name          = "Host_localhost_HEADER"
        action_to_use = "block"
    },
    {
        name          = "PROPFIND_METHOD"
        action_to_use = "block"
    },
    {
        name          = "ExploitablePaths_URIPATH"
        action_to_use = "block"
    },
    {
        name          = "Log4JRCE_QUERYSTRING"
        action_to_use = "block"
    },
    {
        name          = "Log4JRCE_BODY"
        action_to_use = "block"
    },
    {
        name          = "Log4JRCE_URIPATH"
        action_to_use = "block"
    },
    {
        name          = "Log4JRCE_HEADER"
        action_to_use = "block"
    },
    {
        name          = "ReactJSRCE_BODY"
        action_to_use = "block"
    },
]

waf_rule_managed_rules_php_rule_set = true
waf_rule_php_rule_set_wagtail_filter = {
    name                              = "PHPRuleSet_label_excl_wagtail"
    priority                          = 1200
    search_string                     = "wagtail.nationalarchives.gov.uk"
    field_to_match_single_header_name = "host"
    positional_constraint             = "EXACTLY"
}
waf_rule_managed_rules_php_rule_set_priority         = 1290
waf_rule_managed_rules_php_rule_set_overwrite_action = "none"
waf_rule_managed_rules_php_rule_set_action_overrides = [
    {
        name          = "PHPInjections_BODY"
        action_to_use = "block"
    },
    {
        name          = "PHPInjections_QUERYARGUMENTS"
        action_to_use = "block"
    },
    {
        name          = "PHPInjections_URIPATH"
        action_to_use = "block"
    },
    {
        name          = "PHPInjections_HEADER"
        action_to_use = "block"
    },
]

waf_rule_managed_rules_wordpress_rule_set                  = true
waf_rule_managed_rules_wordpress_rule_set_priority         = 1300
waf_rule_managed_rules_wordpress_rule_set_overwrite_action = "none"
waf_rule_managed_rules_wordpress_rule_set_action_overrides = []

waf_rule_exclude_from_sql_injection_managed_rule          = true
waf_rule_exclude_from_sql_injection_managed_rule_priority = 1400
waf_rule_managed_rules_sqli_rule_set                      = true
waf_rule_managed_rules_sqli_rule_set_priority             = 1490
waf_rule_managed_rules_sqli_rule_set_overwrite_action     = "none"
waf_rule_managed_rules_sqli_rule_set_action_overrides = [
    {
        name          = "SQLiExtendedPatterns_HEADER_RC_COUNT"
        action_to_use = "count"
    },
    {
        name          = "SQLiExtendedPatterns_URIPATH_RC_COUNT"
        action_to_use = "count"
    },
    {
        name          = "SQLiExtendedPatterns_BODY_RC_COUNT"
        action_to_use = "count"
    },
    {
        name          = "SQLiExtendedPatterns_QUERYARGUMENTS_RC_COUNT"
        action_to_use = "count"
    },
    {
        name          = "SQLi_URIPATH_RC_COUNT"
        action_to_use = "count"
    },
    {
        name          = "SQLi_COOKIE_RC_COUNT"
        action_to_use = "count"
    },
    {
        name          = "SQLi_BODY_RC_COUNT"
        action_to_use = "count"
    },
    {
        name          = "SQLi_QUERYARGUMENTS_RC_COUNT"
        action_to_use = "count"
    },
    {
        name          = "SQLiExtendedPatterns_QUERYARGUMENTS"
        action_to_use = "block"
    },
    {
        name          = "SQLi_QUERYARGUMENTS"
        action_to_use = "block"
    },
    {
        name          = "SQLi_BODY"
        action_to_use = "block"
    },
    {
        name          = "SQLi_COOKIE"
        action_to_use = "block"
    },
    {
        name          = "SQLi_URIPATH"
        action_to_use = "block"
    },
]
