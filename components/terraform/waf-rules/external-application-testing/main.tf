variable "web_acl_arn" {
    description = "ARN of the WAF Web ACL to which the rule will be added"
    type        = string
}
variable "priority" {
    description = "Priority of the WAF rule. Lower numbers have higher priority."
    type        = number
}
variable "header_value" {
    description = "The value to match in the x-external-access-key header for allowing access."
    type        = string
}

resource "aws_wafv2_web_acl_rule" "waf_rule_external_application_testing" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = "external-application-testing"
    priority    = var.priority
    action {
        allow {}
    }
    statement {
        byte_match_statement {
            positional_constraint = "EXACTLY"
            search_string         = var.header_value
            field_to_match {
                single_header {
                    name = "x-external-access-key"
                }
            }
            text_transformation {
                priority = 0
                type     = "NONE"
            }
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "external-application-testing"
        sampled_requests_enabled   = true
    }
}
