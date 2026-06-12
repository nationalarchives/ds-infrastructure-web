variable "web_acl_arn" {
    description = "ARN of the WAF Web ACL to which the rule will be added"
    type        = string
}
variable "priority" {
    description = "Priority of the WAF rule. Lower numbers have higher priority."
    type        = number
}
variable "countries" {
    description = "List of country codes (in ISO 3166-1 alpha-2 format) to block access from. For example: [\"US\", \"CN\", \"RU\"]"
    type        = list
}
variable "action" {
    description = "Action to take when a request matches the rule."
    type        = string
    default     = "block"
}

resource "aws_wafv2_web_acl_rule" "geo_restrictions" {
    provider = aws.aws-cf-waf

    web_acl_arn = var.web_acl_arn
    name        = "geo_restrictions"
    priority    = var.priority
    action {
        dynamic "allow" {
            for_each = var.action == "allow" ? [""] : []
            content {}
        }
        dynamic "block" {
            for_each = var.action == "block" ? [""] : []
            content {}
        }
        dynamic "count" {
            for_each = var.action == "count" ? [""] : []
            content {}
        }
        dynamic "challenge" {
            for_each = var.action == "challenge" ? [""] : []
            content {}
        }
        dynamic "captcha" {
            for_each = var.action == "captcha" ? [""] : []
            content {}
        }
    }
    statement {
        geo_match_statement {
            country_codes = var.countries
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "geo_restrictions"
        sampled_requests_enabled   = true
    }
}
