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
variable "inspection_level" {
    description = "Inspection level for the AWS Managed Bot Control Rule Set. Valid values are: COMMON, EXTENDED, or TARGETED."
    type        = string
}
variable "action_overrides" {
    description = "List of rule action overrides for specific rules within the AWS Managed Bot Control Rule Set. Each override should specify the rule name and the action to use (count, block, challenge, or captcha)."
    type = list(object({
        name          = string
        action_to_use = string
    }))
}

resource "aws_wafv2_web_acl_rule" "AWSManagedRulesBotControlRuleSet" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = "AWSManagedRulesBotControlRuleSet"
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
            name        = "AWSManagedRulesBotControlRuleSet"
            vendor_name = "AWS"
            managed_rule_group_configs {
                aws_managed_rules_bot_control_rule_set {
                    inspection_level = var.inspection_level
                }
            }
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
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesBotControlRuleSet"
        sampled_requests_enabled   = true
    }
}
