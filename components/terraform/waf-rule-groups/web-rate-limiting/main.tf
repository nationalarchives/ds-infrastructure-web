resource "aws_wafv2_rule_group" "web_rate_limiting_rg" {
    name     = "web-rate-limiting-rg"
    scope    = "CLOUDFRONT"
    region   = "us-east-1"
    capacity = 50

    rule {
        name     = "exclude-by-path"
        priority = 0
        action {
            count {}
        }
        rule_label {
            name = "include-in-rate-limiting"
        }
        statement {
            or_statement {
                statement {
                    not_statement {
                        statement {
                            byte_match_statement {
                                positional_constraint = "STARTS_WITH"
                                search_string         = "/images"
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
                statement {
                    not_statement {
                        statement {
                            byte_match_statement {
                                positional_constraint = "STARTS_WITH"
                                search_string         = "/media"
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
                statement {
                    not_statement {
                        statement {
                            byte_match_statement {
                                positional_constraint = "STARTS_WITH"
                                search_string         = "/static"
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
                statement {
                    not_statement {
                        statement {
                            byte_match_statement {
                                positional_constraint = "STARTS_WITH"
                                search_string         = "/wp-content"
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
            }
        }
        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "web-include-in-rate-limiting-label"
            sampled_requests_enabled   = true
        }
    }
    rule {
        name     = "ip-match"
        priority = 1
        action {
            challenge {}
        }
        rule_label {
            name = "geo-match-rate-limit"
        }
        statement {
            rate_based_statement {
                aggregate_key_type    = "IP"
                evaluation_window_sec = 60
                limit                 = 100
                scope_down_statement {
                    label_match_statement {
                        key   = "include-in-rate-limiting"
                        scope = "LABEL"
                    }
                }
            }
        }
        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "web-rate-limit-ip-match"
            sampled_requests_enabled   = true
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "web-rate-limiting"
        sampled_requests_enabled   = true
    }
}
