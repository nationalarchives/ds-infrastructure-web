resource "aws_wafv2_rule_group" "web_emergency_rg" {
    name     = "web-emergency-rg"
    scope    = "CLOUDFRONT"
    region   = "us-east-1"
    capacity = 150

    rule {
        name     = "geo-match"
        priority = 1
        action {
            count {}
        }
        statement {

            geo_match_statement {
                country_codes = ["BR", "RU", "CN"]
            }
        }
        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "web-emergency-geo-match"
            sampled_requests_enabled   = true
        }
    }

    rule {
        name     = "url-match"
        priority = 2
        action {
            block {}
        }
        statement {
            or_statement {
                statement {
                    byte_match_statement {
                        positional_constraint = "STARTS_WITH"
                        search_string         = "/a2a"
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
                        positional_constraint = "STARTS_WITH"
                        search_string         = "/nra"
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
            metric_name                = "web-emergency-url-match"
            sampled_requests_enabled   = true
        }
    }
    rule {
        name     = "block-asp"
        priority = 3
        action {
            block {}
        }
        statement {
            and_statement {
                statement {
                    not_statement {
                        statement {
                            byte_match_statement {
                                positional_constraint = "STARTS_WITH"
                                search_string         = "/pronom"
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
                    byte_match_statement {
                        positional_constraint = "CONTAINS"
                        search_string         = ".asp"
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
            metric_name                = "web-emergency-block-asp"
            sampled_requests_enabled   = true
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "web-emergency"
        sampled_requests_enabled   = true
    }
}
