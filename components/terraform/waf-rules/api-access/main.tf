variable "web_acl_arn" {
    description = "ARN of the WAF Web ACL to which the rule will be added"
    type        = string
}
variable "priority" {
    description = "Priority of the WAF rule. Lower numbers have higher priority."
    type        = number
}

resource "aws_wafv2_web_acl_rule" "waf_rule_api_access" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = "api-access"
    priority    = var.priority
    action {
        allow {}
    }
    statement {
        byte_match_statement {
            positional_constraint = "STARTS_WITH"
            search_string         = "/api/v2/"
            field_to_match {
                uri_path {}
            }
            text_transformation {
                priority = 0
                type     = "LOWERCASE"
            }
        }
    }
    rule_label {
        name = "api:access"
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "api-access"
        sampled_requests_enabled   = true
    }
}
