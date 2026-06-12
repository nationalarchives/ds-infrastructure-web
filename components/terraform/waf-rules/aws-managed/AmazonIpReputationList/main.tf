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

resource "aws_wafv2_web_acl_rule" "AWSManagedRulesAmazonIpReputationList" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = "AWSManagedRulesAmazonIpReputationList"
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
            name        = "AWSManagedRulesAmazonIpReputationList"
            vendor_name = "AWS"
            dynamic "rule_action_override" {
                for_each = toset(var.action_overrides)
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
        metric_name                = "AWSManagedRulesAmazonIpReputationList"
        sampled_requests_enabled   = true
    }
}
