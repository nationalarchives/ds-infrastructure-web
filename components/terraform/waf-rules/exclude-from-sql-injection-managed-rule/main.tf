variable "web_acl_arn" {
    description = "ARN of the WAF Web ACL to which the rule will be added"
    type        = string
}
variable "priority" {
    description = "Priority of the AWS Managed Bot Control Rule Set rule in the Web ACL"
    type        = number
}

resource "aws_wafv2_web_acl_rule" "exclude_from_sql_injection_managed_rule" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = "exclude-from-sql-injection-managed-rule"
    priority    = var.priority
    action {
        count {}
    }
    rule_label {
        name = "SQLiRuleSet_include_request"
    }
    statement {
        not_statement {
            statement {
                or_statement {
                    statement {
                        byte_match_statement {
                            positional_constraint = "STARTS_WITH"
                            search_string         = "/e179/"
                            field_to_match {
                                uri_path {}
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
                            search_string         = "/request-a-military-service-record/upload-a-proof-of-death/"
                            field_to_match {
                                single_header {
                                    name = "host"
                                }
                            }
                            text_transformation {
                                priority = 0
                                type     = "NONE"
                            }
                        }
                    }
                }
            }
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "exclude_from_sql_injection_managed_rule"
        sampled_requests_enabled   = true
    }
}
