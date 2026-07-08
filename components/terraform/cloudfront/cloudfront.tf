resource "aws_cloudfront_distribution" "web" {
    dynamic "origin" {
        for_each = local.cloudfront_distribution.cloudfront_origins
        content {
            domain_name = origin.value["domain_name"]
            origin_id   = origin.value["origin_id"]

        custom_origin_config {
            http_port              = 80
            https_port             = 443
            origin_protocol_policy = "https-only"
            origin_ssl_protocols = ["TLSv1.2"]
        }

        custom_header {
            name  = var.custom_header_name
            value = var.custom_header_value
        }
    }
}

    http_version = "http1.1"
    price_class = lookup(local.cloudfront_distribution, "price_class", "")
    enabled = lookup(local.cloudfront_distribution, "enabled", "")

    dynamic "logging_config" {
        for_each = lookup(local.cloudfront_distribution, "enable_logging", [])
        content {
            bucket = "ds-${var.account}-logfiles.s3.amazonaws.com"
            prefix = "web/cloudfront/"
        }
    }

    aliases = lookup(local.cloudfront_distribution, "aliases", "")

    default_cache_behavior {
        target_origin_id = local.origin_id_www
        allowed_methods = lookup(local.cloudfront_distribution, "default_behaviour_allowed_methods", "")
        cached_methods = lookup(local.cloudfront_distribution, "default_behaviour_cached_methods", "")

        cache_policy_id          = local.default_cache_policy_id
        origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id

        viewer_protocol_policy = lookup(local.cloudfront_distribution, "behaviour_default_viewer_protocol_policy", "")
        compress = lookup(local.cloudfront_distribution, "behaviour_compress", "")
    }

    # Managed Caching Disabled and Managed All Viewer policies
    dynamic "ordered_cache_behavior" {
        for_each = local.ordered_cache_behaviors
        iterator = b
        content {
            path_pattern     = b.value.path_pattern
            target_origin_id = b.value.target_origin_id
            allowed_methods  = b.value.allowed_methods
            cached_methods   = b.value.cached_methods

            cache_policy_id          = b.value.cache_policy_id
            origin_request_policy_id = b.value.origin_request_policy_id
            response_headers_policy_id = lookup(b.value, "response_headers_policy_id", null)

            viewer_protocol_policy = b.value.viewer_protocol_policy
            compress               = b.value.compress

            min_ttl     = b.value.min_ttl
            default_ttl = b.value.default_ttl
            max_ttl     = b.value.max_ttl
            dynamic function_association {
                for_each = lookup(b.value, "functions", [])
                iterator = f
                content {
                    function_arn = f.value.function_arn
                    event_type   = f.value.event_type
                }
            }
        }
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    tags = merge(var.default_tags, {
        service = "web"
    })

    viewer_certificate {
        cloudfront_default_certificate = false
        acm_certificate_arn            = var.wildcard_certificate_arn
        ssl_support_method             = "sni-only"
        minimum_protocol_version       = "TLSv1.2_2021"
    }

    # get arn to indicate WAFv2
    web_acl_id = element(split(",", var.web_waf_info), 1)
}
