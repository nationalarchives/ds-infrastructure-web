resource "aws_wafv2_rule_group" "web_targetted_blocks" {
    name     = "web-targetted-blocks-rg"
    scope    = "CLOUDFRONT"
    region   = "us-east-1"
    capacity = 150
    rule {
        name     = "bytespider"
        priority = 1
        action {
            block {}
        }
        statement {
            label_match_statement {
                scope = "LABEL"
                key   = "awswaf:managed:aws:bot-control:bot:name:bytespider"
            }
        }
        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "web-block-bytespider"
            sampled_requests_enabled   = true
        }
    }
    rule {
        name     = "mozlila"
        priority = 2
        action {
            block {}
        }
        statement {
            byte_match_statement {
                positional_constraint = "CONTAINS"
                search_string         = "mozlila"
                field_to_match {
                    single_header {
                        name = "user-agent"
                    }
                }
                text_transformation {
                    priority = 0
                    type     = "LOWERCASE"
                }
            }
        }
        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "web-block-mozlila"
            sampled_requests_enabled   = true
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "web-targetted-blocks"
        sampled_requests_enabled   = true
    }
}
