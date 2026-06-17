locals {
    Managed_AllViewer_origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    Managed_CachingDisabled_cache_policy_id    = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    default_cache_policy_id                    = var.web_5_minute_update_policy_id

    origin_id_www     = "staging-www.nationalarchives.gov.uk"
    origin_id_wagtail = "staging-wagtail.nationalarchives.gov.uk"

    cloudfront_distribution = {
        "cloudfront_origins" = [
            {
                "origin_id"   = local.origin_id_www
                "domain_name" = var.web_reverse_proxy_lb_dns_name
            },
            {
                "origin_id"   = local.origin_id_wagtail
                "domain_name" = var.web_reverse_proxy_lb_dns_name
            },
        ]
        "create_distribution" = true
        "domain_name"         = var.web_reverse_proxy_lb_dns_name
        "origin_id"           = local.origin_id_www
        "price_class"         = "PriceClass_100"
        "enabled"             = true
        "aliases" = [
            local.origin_id_www,
            local.origin_id_wagtail,
        ]
        "default_behaviour_allowed_methods" = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        "default_behaviour_cached_methods" = ["GET", "HEAD"]
        "behaviour_default_viewer_protocol_policy" = "redirect-to-https"
        "behaviour_viewer_protocol_policy"         = "redirect-to-https"
        "behaviour_compress"                       = true
        # The cfd_enable_logging is a collection used to enable or disable logging
        # - To enable logging, set it to a single item list (any value will do)
        # - To disable logging, set it to an empty list
        "enable_logging" = [true]
    }

    ordered_cache_behaviors = [
        {
            path_pattern             = "/aaa/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/book-a-reading-room-visit/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/cabinetpaperssearch/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/e179/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/education/candp/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/education/focuson/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/education/medieval/magna-carta/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/imglib/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/information-management/browse-guidance-standards/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/infoservice/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/magna-carta/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/pronom/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/streamline/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/media/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = var.web_monthly_update_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/static/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = var.web_monthly_update_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/sitemaps/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = var.web_weekly_update_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/explore-the-collection/search/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/preview/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/admin/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_wagtail
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/cookies/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = local.Managed_CachingDisabled_cache_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_www
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
        {
            path_pattern             = "/wagtail-static/*"
            allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
            cache_policy_id          = var.web_monthly_update_policy_id
            cached_methods = ["GET", "HEAD"]
            compress                 = true
            default_ttl              = 0
            max_ttl                  = 0
            min_ttl                  = 0
            origin_request_policy_id = local.Managed_AllViewer_origin_request_policy_id
            smooth_streaming         = false
            target_origin_id         = local.origin_id_wagtail
            trusted_key_groups = []
            trusted_signers = []
            viewer_protocol_policy   = "redirect-to-https"
        },
    ]
}
