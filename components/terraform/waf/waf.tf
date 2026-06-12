resource "aws_wafv2_ip_set" "web_access" {
    provider = aws.aws-cf-waf

    name               = "web-access"
    description        = "IP set containing allowed or blocked IP addresses, depending on the default action."
    scope              = "CLOUDFRONT"
    ip_address_version = "IPV4"
    addresses          = var.site_ips

    tags = var.tags

    lifecycle {
        ignore_changes = [addresses]
    }
}

resource "aws_wafv2_web_acl" "web" {
    provider = aws.aws-cf-waf

    name  = "web"
    scope = "CLOUDFRONT"

    default_action {
        dynamic "allow" {
            for_each = var.waf_rule_default_action_allow == true ? [""] : []
            content {}
        }
        dynamic "block" {
            for_each = var.waf_rule_default_action_allow == false ? [""] : []
            content {}
        }
    }

    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "aws-waf-logs-web"
        sampled_requests_enabled   = true
    }

    lifecycle {
        ignore_changes = [rule]
    }
    tags = var.tags
}

resource "aws_wafv2_regex_pattern_set" "web_admin_url_pattern" {
    provider = aws.aws-cf-waf

    name        = "web-admin-url-pattern"
    description = "pattern for web admin section"
    scope       = "CLOUDFRONT"

    regular_expression {
        regex_string = "^https:\\/\\/wp-admin/*"
    }

    tags = var.tags
}

