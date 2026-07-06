waf_rule_emergency_rule_group = false
waf_rule_group_emergency      = false

waf_rule_external_service_testing_rule_group = true
waf_rule_group_external_service_testing      = true

waf_rule_known_ips_rule_group = true
waf_rule_group_known_ips      = true

waf_rule_api_access_rule_group = true
waf_rule_group_api_access      = true

waf_rule_targetted_blocks_rule_group = false
waf_rule_group_targetted_blocks      = false

waf_rule_rate_limiting_rule_group = false
waf_rule_group_rate_limiting      = false

waf_rule_exclude_from_sql_injection_managed_rule          = true
waf_rule_exclude_from_sql_injection_managed_rule_priority = 800

waf_rule_aws_managed_bot_control_rule_set                  = true
waf_rule_aws_managed_bot_control_rule_set_priority         = 500
waf_rule_aws_managed_bot_control_rule_set_overwrite_action = "count"
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
        action_to_use = "block"
    },
    {
        name          = "SignalKnownBotDataCenter"
        action_to_use = "block"
    },
    {
        name          = "SignalNonBrowserUserAgent"
        action_to_use = "block"
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
        action_to_use = "block"
    },
    {
        name          = "TGT_TokenReuseIp"
        action_to_use = "block"
    },
    {
        name          = "TGT_ML_CoordinatedActivityMedium"
        action_to_use = "block"
    },
    {
        name          = "CaTGT_ML_CoordinatedActivityHighteoryAI"
        action_to_use = "block"
    },
]

waf_rule_managed_rules_known_bad_inputs                  = true
waf_rule_managed_rules_known_bad_inputs_priority         = 600
waf_rule_managed_rules_known_bad_inputs_overwrite_action = "none"
waf_rule_managed_rules_known_bad_inputs_action_overrides = []

waf_rule_managed_rules_wordpress_rule_set                  = true
waf_rule_managed_rules_wordpress_rule_set_priority         = 700
waf_rule_managed_rules_wordpress_rule_set_overwrite_action = "none"
waf_rule_managed_rules_wordpress_rule_set_action_overrides = []

waf_rule_managed_rules_sqli_rule_set                  = true
waf_rule_managed_rules_sqli_rule_set_priority         = 890
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

