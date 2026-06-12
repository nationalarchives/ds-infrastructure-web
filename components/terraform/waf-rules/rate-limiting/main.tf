variable "web_acl_arn" {
    description = "ARN of the WAF Web ACL to which the rule will be added"
    type        = string
}
variable "priority" {
    description = "Priority of the WAF rule. Lower numbers have higher priority."
    type        = number
}
variable "limit" {
    description = "The maximum number of requests allowed in the specified evaluation window before the rule action is triggered."
    type        = number
}
variable "aggregate_key_type" {
    description = "The method used to aggregate the request counts. Valid values are: IP, FORWARDED_IP, or CUSTOM_KEY."
    type        = string
}
variable "evaluation_window_sec" {
    description = "The time period, in seconds, over which the specified rate limit applies. Valid values are between 1 and 3600 seconds."
    type        = number
}

resource "aws_wafv2_web_acl_rule" "waf_rule_rate_limiting" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = "rate-limiting"
    priority    = var.priority
    action {
        block {}
    }
    statement {
        rate_based_statement {
            limit                 = var.limit
            aggregate_key_type    = var.aggregate_key_type
            evaluation_window_sec = var.evaluation_window_sec
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "rate-limiting"
        sampled_requests_enabled   = true
    }
}
