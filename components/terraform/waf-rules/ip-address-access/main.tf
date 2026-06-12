variable "web_acl_arn" {
    description = "ARN of the WAF Web ACL to which the rule will be added"
    type        = string
}
variable "priority" {
    description = "Priority of the WAF rule. Lower numbers have higher priority."
    type        = number
}
variable "waf_rule_default_action_allow" {
    description = "Whether the default action for the WAF rule should be allow or block."
    type        = bool
}
variable "access_ip_set_arn" {
    description = "ARN of IP set containing allowed or blocked IP addresses, depending on the default action."
    type        = string
}

resource "aws_wafv2_web_acl_rule" "waf_rule_ip_address_access" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = "ip-address-access"
    priority    = var.priority
    action {
        dynamic "allow" {
            for_each = var.waf_rule_default_action_allow == false ? [""] : []
            content {}
        }
        dynamic "block" {
            for_each = var.waf_rule_default_action_allow == true ? [""] : []
            content {}
        }
    }
    statement {
        ip_set_reference_statement {
            arn = var.access_ip_set_arn
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-ip-access-rule"
        sampled_requests_enabled   = true
    }
}
