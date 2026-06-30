variable "environment" {}

variable "allow_action" {
    description = "action for the known ipset opposite of the web acl access"
    default     = false
}
variable "known_ipset_arn" {
    description = "ipset"
}
variable "exception_ipset_arn" {
    description = "ipset exception to known ipset"
}
variable "tourchbox_seo_audit_ipset_arn" {
    description = "ipset exception to known ipset"
}
variable "wagtail_admin_ipset_arn" {
    description = "wagtail admin ipset arn"
}
variable "wp_admin_ipset_arn" {
    description = "wordpress admin ipset arn"
}

locals {
    wagtail_admin_prefix = var.environment == "live" ? "wagtail." : "${var.environment}-wagtail."
    wp_admin_prefix      = "${var.environment}wp."
}

resource "aws_wafv2_rule_group" "web_known_ips_rg" {
    name     = "web-known-ips-rg"
    scope    = "CLOUDFRONT"
    region   = "us-east-1"
    capacity = 50

    rule {
        name     = "known-ips-list"
        priority = 0
        action {
            dynamic "allow" {
                for_each = var.allow_action == false ? [""] : []
                content {}
            }
            dynamic "block" {
                for_each = var.allow_action == true ? [""] : []
                content {}
            }
        }

        statement {
            ip_set_reference_statement {
                arn = var.known_ipset_arn
            }
        }
        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "web-known-ips-list"
            sampled_requests_enabled   = true
        }
    }
    rule {
        name     = "known-ips-list-exceptions"
        priority = 1
        action {
            dynamic "allow" {
                for_each = var.allow_action == true ? [""] : []
                content {}
            }
            dynamic "block" {
                for_each = var.allow_action == false ? [""] : []
                content {}
            }
        }

        statement {
            ip_set_reference_statement {
                arn = var.exception_ipset_arn
            }
        }
        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "web-known-ips-list-exceptions"
            sampled_requests_enabled   = true
        }
    }
    rule {
        name     = "torchbox-seo-audit-ips-list-exceptions"
        priority = 1
        action {
            allow {}
        }

        statement {
            ip_set_reference_statement {
                arn = var.tourchbox_seo_audit_ipset_arn
            }
        }
        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "web-torchbox-seo-audit-ips-list-exceptions"
            sampled_requests_enabled   = true
        }
    }
    rule {
        name     = "wagtail-admin-ips"
        priority = 2
        action {
            allow {}
        }
        statement {
            and_statement {
                statement {
                    byte_match_statement {
                        positional_constraint = "STARTS_WITH"
                        search_string         = local.wagtail_admin_prefix
                        field_to_match {
                            single_header {
                                name = "host"
                            }
                        }
                        text_transformation {
                            priority = 0
                            type     = "LOWERCASE"
                        }
                    }
                }
                statement {
                    ip_set_reference_statement {
                        arn = var.wagtail_admin_ipset_arn
                    }
                }
            }
        }
        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "wagtail-admin-ips"
            sampled_requests_enabled   = true
        }
    }
    rule {
        name     = "wp-admin-ips"
        priority = 3
        action {
            allow {}
        }
        statement {
            and_statement {
                statement {
                    byte_match_statement {
                        positional_constraint = "STARTS_WITH"
                        search_string         = local.wp_admin_prefix
                        field_to_match {
                            single_header {
                                name = "host"
                            }
                        }
                        text_transformation {
                            priority = 0
                            type     = "LOWERCASE"
                        }
                    }
                }
                statement {
                    ip_set_reference_statement {
                        arn = var.wp_admin_ipset_arn
                    }
                }
            }
        }
        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "web-wp-admin-ips"
            sampled_requests_enabled   = true
        }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "web-known-ips-list-rules"
        sampled_requests_enabled   = true
    }
}
