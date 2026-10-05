locals {
  streamline_hpp_domain = var.environment == "live" ? "streamline-hpp.nationalarchives.gov.uk" : "${var.environment}-streamline-hpp.nationalarchives.gov.uk"

  streamline_hpp_origin_id = var.web_reverse_proxy_lb_dns_name
}

resource "aws_cloudfront_distribution" "streamline_hpp" {
  enabled = true

  comment = "CloudFront distribution for Streamline HPP Worldpay notifications with mTLS"

  web_acl_id = var.web_waf_arn

  aliases = [
    local.streamline_hpp_domain
  ]

  price_class  = "PriceClass_All"
  http_version = "http2"
  is_ipv6_enabled = true

  origin {
    domain_name = var.web_reverse_proxy_lb_dns_name
    origin_id   = local.streamline_hpp_origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = local.streamline_hpp_origin_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
    origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id

    compress = true
  }

  viewer_certificate {
    acm_certificate_arn      = var.wildcard_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  viewer_mtls_config {
    mode = "required"

    trust_store_config {
      trust_store_id                 = aws_cloudfront_trust_store.worldpay.id
      advertise_trust_store_ca_names = true
      ignore_certificate_expiry      = false
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

    tags = merge(var.default_tags, {
    Name = "streamline-hpp"
  })
}
