variable "web_acl_arn" {
    description = "ARN of the WAF Web ACL to which the rule will be added"
    type        = string
}
variable "priority" {
    description = "Priority of the WAF rule. Lower numbers have higher priority."
    type        = number
}

resource "aws_wafv2_web_acl_rule" "mozlila_digitalocean" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = "mozlila_digitalocean"
    priority    = var.priority
    action {
        count {}
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
        metric_name                = "mozlila_digitalocean"
        sampled_requests_enabled   = true
    }
}
