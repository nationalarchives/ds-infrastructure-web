variable "web_acl_arn" {
    description = "ARN of the WAF Web ACL to which the rule will be added"
    type        = string
}
variable "priority" {
    description = "Priority of the WAF rule. Lower numbers have higher priority."
    type        = number
}
variable "rule_group_arn" {}

resource "aws_wafv2_web_acl_rule" "external_service_testing_rule_group" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = "external-service-testing-rule-group"
    priority    = var.priority
    override_action {
        none {}
    }
    statement {
        rule_group_reference_statement {
            arn = var.rule_group_arn
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "external-service-testing-rule-container"
        sampled_requests_enabled   = true
    }
}
