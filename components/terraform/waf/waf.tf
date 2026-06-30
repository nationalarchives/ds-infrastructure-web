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

resource "aws_wafv2_ip_set" "web_exceptions" {
    provider = aws.aws-cf-waf

    name               = "web-exceptions"
    description        = "IP set containing exception IP addresses, depending on the default action."
    scope              = "CLOUDFRONT"
    ip_address_version = "IPV4"
    addresses          = var.exception_site_ips

    tags = var.tags

    lifecycle {
        ignore_changes = [addresses]
    }
}

resource "aws_wafv2_ip_set" "wp_admins" {
    provider = aws.aws-cf-waf

    name               = "wp-admins"
    description        = "IP set containing WordPress admin IP addresses."
    scope              = "CLOUDFRONT"
    ip_address_version = "IPV4"
    addresses          = var.wp_admin_ips

    tags = var.tags

    lifecycle {
        ignore_changes = [addresses]
    }
}

resource "aws_wafv2_ip_set" "wagtail_admins" {
    provider = aws.aws-cf-waf

    name               = "wagtail-admins"
    description        = "IP set containing Wagtail admin IP addresses."
    scope              = "CLOUDFRONT"
    ip_address_version = "IPV4"
    addresses          = var.wagtail_admin_ips

    tags = var.tags

    lifecycle {
        ignore_changes = [addresses]
    }
}

resource "aws_wafv2_ip_set" "tourchbox_seo_audit" {
    provider = aws.aws-cf-waf

    name               = "tourchbox-seo-audit"
    description        = "IP set containing Touchbox SEO audit IP addresses."
    scope              = "CLOUDFRONT"
    ip_address_version = "IPV4"
    addresses          = var.tourchbox_seo_audit_ips

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
