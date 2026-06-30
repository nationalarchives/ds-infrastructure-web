variable "unthrottled_api_header_value" {}

resource "aws_wafv2_rule_group" "web_api_access" {
    name     = "web-api-access"
    scope    = "CLOUDFRONT"
    region   = "us-east-1"
    capacity = 50

    rule {
        name     = "open-api"
        priority = 0
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
        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "web-open-api"
            sampled_requests_enabled   = true
        }
    }
    rule {
        name     = "external-application-testing"
        priority = 0
        action {
            allow {}
        }
        statement {
            and_statement {
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
                statement {
                    byte_match_statement {
                        positional_constraint = "EXACTLY"
                        search_string         = var.unthrottled_api_header_value
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
            }
        }
        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "web-external-application-testing"
            sampled_requests_enabled   = true
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "web-api-access"
        sampled_requests_enabled   = true
    }
}
