variable "web_acl_arn" {
    description = "ARN of the WAF Web ACL to which the rule will be added"
    type        = string
}
variable "priority" {
    description = "Priority of the AWS Managed Bot Control Rule Set rule in the Web ACL"
    type        = number
}
variable "overwrite_action" {
    description = "Action to use instead of the AWS Managed Rule Group's default action. Valid values are: none, count."
    type        = string
}
variable "action_overrides" {
    description = "List of rule action overrides for specific rules within the AWS Managed Bot Control Rule Set. Each override should specify the rule name and the action to use (count, block, challenge, or captcha)."
    type = list(object({
        name          = string
        action_to_use = string
    }))
}
variable "wagtail_filter_values" {
    description = "Optional step-down rule to add as a NOT statement around the AWS Managed Rule Group statement. This can be used to exclude certain requests from being evaluated by the managed rule group. The step-down rule should specify the positional constraint, search string, and field to match for a byte match statement."
    type = object({
        name                              = string
        priority                          = number
        positional_constraint             = string
        search_string                     = string
        field_to_match_single_header_name = string
    })
}

resource "aws_wafv2_web_acl_rule" "PHPRuleSet_label_excl_wagtail" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = var.wagtail_filter_values.name
    priority    = var.wagtail_filter_values.priority
    action {
        count {}
    }
    rule_label {
        name = "PHPRuleSet_include_request"
    }
    statement {
        not_statement {
            statement {
                byte_match_statement {
                    positional_constraint = var.wagtail_filter_values.positional_constraint
                    search_string         = var.wagtail_filter_values.search_string
                    field_to_match {
                        single_header {
                            name = var.wagtail_filter_values.field_to_match_single_header_name
                        }
                    }
                    text_transformation {
                        priority = 0
                        type     = "LOWERCASE"
                    }
                }
            }
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = var.wagtail_filter_values.name
        sampled_requests_enabled   = true
    }
}


resource "aws_wafv2_web_acl_rule" "AWSManagedRulesPHPRuleSet" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = "AWSManagedRulesPHPRuleSet"
    priority    = var.priority
    override_action {
        dynamic "none" {
            for_each = var.overwrite_action == "none" ? [""] : []
            content {}
        }
        dynamic "count" {
            for_each = var.overwrite_action == "count" ? [""] : []
            content {}
        }
    }
    statement {
        managed_rule_group_statement {
            name        = "AWSManagedRulesPHPRuleSet"
            vendor_name = "AWS"
            dynamic "rule_action_override" {
                for_each = var.action_overrides
                iterator = rao
                content {
                    name = rao.value.name
                    action_to_use {
                        dynamic "allow" {
                            for_each = rao.value.action_to_use == "allow" ? [""] : []
                            content {}
                        }
                        dynamic "count" {
                            for_each = rao.value.action_to_use == "count" ? [""] : []
                            content {}
                        }
                        dynamic "block" {
                            for_each = rao.value.action_to_use == "block" ? [""] : []
                            content {}
                        }
                        dynamic "challenge" {
                            for_each = rao.value.action_to_use == "challenge" ? [""] : []
                            content {}
                        }
                        dynamic "captcha" {
                            for_each = rao.value.action_to_use == "captcha" ? [""] : []
                            content {}
                        }
                    }
                }
            }
            scope_down_statement {
                label_match_statement {
                    key   = "PHPRuleSet_include_request"
                    scope = "LABEL"
                }
            }
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesPHPRuleSet"
        sampled_requests_enabled   = true
    }
}
