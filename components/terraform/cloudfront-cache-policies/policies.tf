resource "aws_cloudfront_cache_policy" "help_with_your_research" {
    name    = "help-with-your-research"
    comment = "include host to header and limit query strings"

    default_ttl = var.help_with_your_research_default_ttl
    min_ttl     = var.help_with_your_research_min_ttl
    max_ttl     = var.help_with_your_research_max_ttl

    parameters_in_cache_key_and_forwarded_to_origin {
        cookies_config {
            cookie_behavior = "none"
        }
        headers_config {
            header_behavior = "whitelist"
            headers {
                items = ["Host"]
            }
        }
        query_strings_config {
            query_string_behavior = "whitelist"
            query_strings {
                items = [
                    "research-category",
                    "letter"
                ]
            }
        }
        enable_accept_encoding_brotli = true
        enable_accept_encoding_gzip   = true
    }
}

resource "aws_cloudfront_cache_policy" "web_monthly_update" {
    name        = "web-monthly-update"
    comment     = "keeping cache for one month"
    default_ttl = 604800
    max_ttl     = 2592000
    min_ttl     = 300
    parameters_in_cache_key_and_forwarded_to_origin {
        enable_accept_encoding_gzip   = true
        enable_accept_encoding_brotli = true
        cookies_config {
            cookie_behavior = "none"
        }
        headers_config {
            header_behavior = "none"
        }
        query_strings_config {
            query_string_behavior = "all"
        }
    }
}

resource "aws_cloudfront_cache_policy" "web_weekly_update" {
    name        = "web-weekly-update"
    comment     = "keeping cache for one month"
    default_ttl = 86400
    max_ttl     = 604800
    min_ttl     = 300
    parameters_in_cache_key_and_forwarded_to_origin {
        enable_accept_encoding_gzip   = true
        enable_accept_encoding_brotli = true
        cookies_config {
            cookie_behavior = "none"
        }
        headers_config {
            header_behavior = "none"
        }
        query_strings_config {
            query_string_behavior = "all"
        }
    }
}

resource "aws_cloudfront_cache_policy" "web_5_minute_update" {
    name        = "web-5-minute-update"
    comment     = "keeping cache for one month"
    default_ttl = var.web_5_minute_update_default_ttl
    max_ttl     = var.web_5_minute_update_max_ttl
    min_ttl     = var.web_5_minute_update_min_ttl
    parameters_in_cache_key_and_forwarded_to_origin {
        enable_accept_encoding_gzip   = true
        enable_accept_encoding_brotli = true
        cookies_config {
            cookie_behavior = "all"
        }
        headers_config {
            header_behavior = "none"
        }
        query_strings_config {
            query_string_behavior = "all"
        }
    }
}
