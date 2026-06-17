waf_rule_external_application_testing          = true
waf_rule_external_application_testing_priority = 0

waf_rule_rate_limiting                       = false
waf_rule_rate_limiting_priority              = 5
waf_rule_rate_limiting_limit                 = 2000
waf_rule_rate_limiting_aggregate_key_type    = "IP"
waf_rule_rate_limiting_evaluation_window_sec = 300

waf_rule_exclude_from_sql_injection_managed_rule          = true
waf_rule_exclude_from_sql_injection_managed_rule_priority = 5

waf_rule_api_unthrottled_access          = false
waf_rule_api_unthrottled_access_priority = 2

waf_rule_geo_restrictions          = false
waf_rule_geo_restriction_priority  = 4
waf_rule_geo_restriction_countries = ["BR", "RU", "CN"]

waf_rule_ip_address_access          = true
waf_rule_ip_address_access_priority = 1

waf_rule_block_bytespider          = false
waf_rule_block_bytespider_priority = 6

waf_rule_mozlila_digitalocean          = false
waf_rule_mozlila_digitalocean_priority = 7

waf_rule_aws_managed_bot_control_rule_set                  = true
waf_rule_aws_managed_bot_control_rule_set_priority         = 2
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

waf_rule_aws_managed_amazon_ip_reputation_list           = false
waf_rule_aws_managed_amazon_ip_reputation_list_priority  = 8
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

waf_rule_managed_rules_linux_rule_set                  = false
waf_rule_managed_rules_linux_rule_set_priority         = 9
waf_rule_managed_rules_linux_rule_set_overwrite_action = "none"
waf_rule_managed_rules_linux_rule_set_action_overrides = []

waf_rule_managed_rules_known_bad_inputs                  = true
waf_rule_managed_rules_known_bad_inputs_priority         = 3
waf_rule_managed_rules_known_bad_inputs_overwrite_action = "none"
waf_rule_managed_rules_known_bad_inputs_action_overrides = []

waf_rule_managed_rules_wordpress_rule_set                  = true
waf_rule_managed_rules_wordpress_rule_set_priority         = 4
waf_rule_managed_rules_wordpress_rule_set_overwrite_action = "none"
waf_rule_managed_rules_wordpress_rule_set_action_overrides = []

waf_rule_managed_rules_sqli_rule_set                  = true
waf_rule_managed_rules_sqli_rule_set_priority         = 6
waf_rule_managed_rules_sqli_rule_set_overwrite_action = "none"
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

