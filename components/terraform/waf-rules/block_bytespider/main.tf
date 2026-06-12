variable "web_acl_arn" {
    description = "ARN of the WAF Web ACL to which the rule will be added"
    type        = string
}
variable "priority" {
    description = "Priority of the WAF rule. Lower numbers have higher priority."
    type        = number
}

resource "aws_wafv2_web_acl_rule" "waf_rule_block_bytespider" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = "block_bytespider"
    priority    = var.priority
    action {
        block {}
    }
    statement {
        label_match_statement {
            key   = "awswaf:managed:aws:bot-control:bot:name:bytespider"
            scope = "LABEL"
        }
    }

    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "block_bytespider"
        sampled_requests_enabled   = true
    }
}
