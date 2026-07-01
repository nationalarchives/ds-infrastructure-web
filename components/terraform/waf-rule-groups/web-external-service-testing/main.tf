variable "x_external_access_key" {}

resource "aws_wafv2_rule_group" "web_external_service_testing" {
    name     = "web-external-service-testing"
    scope    = "CLOUDFRONT"
    region   = "us-east-1"
    capacity = 50

    rule {
        name     = "x-key"
        priority = 0
        action {
            allow {}
        }
        statement {
            byte_match_statement {
                positional_constraint = "EXACTLY"
                search_string         = var.x_external_access_key
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
            metric_name                = "x-key"
            sampled_requests_enabled   = true
        }
    }
    rule {
        name     = "kuma-health-check"
        priority = 1
        action {
            allow {}
        }
        statement {
            byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "/Uptime-Kuma"
                field_to_match {
                    single_header {
                        name = "user-agent"

                    }
                }
                text_transformation {
                    priority = 0
                    type     = "NONE"
                }
            }}
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "web-external-service-testing"
        sampled_requests_enabled   = true
    }
}
