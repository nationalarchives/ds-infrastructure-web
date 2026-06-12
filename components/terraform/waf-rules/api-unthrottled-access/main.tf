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

resource "aws_wafv2_web_acl_rule" "waf_rule_api_unthrottled_access" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = "api-unthrottled-access"
    priority    = var.priority
    action {
        allow {}
    }
    statement {
        and_statement {
            statement {
                byte_match_statement {
                    positional_constraint = "EXACTLY"
                    search_string         = var.header_value
                    field_to_match {
                        single_header {
                            name = "x-api-unthrottled"
                        }
                    }
                    text_transformation {
                        priority = 0
                        type     = "NONE"
                    }
                }
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
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "api-unthrottled-access"
        sampled_requests_enabled   = true
    }
}
