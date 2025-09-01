module "etna-route53" {
    source = "./route53"

    user_pool_domain = var.user_pool_domain
    cloudfront_distribution         = module.etna-cognito.cognito_cloudfront_distribution
    cloudfront_distribution_zone_id = module.etna-cognito.cognito_cloudfront_distribution_zone_id
}

resource "aws_route53_record" "web-frontend" {
    zone_id = var.route53_zone                                
    name    = "web-frontend.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
         module.frontend.lb_internal_dns_name
    ]
}

resource "aws_route53_record" "web-enrichment" {
    zone_id = var.route53_zone
    name    = "web-enrichment.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.enrichment.lb_internal_dns_name
    ]    
}

resource "aws_route53_record" "wagtail" {
    zone_id = var.route53_zone
    name    = "wagtail.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.wagtail.lb_internal_dns_name
    ]    
}

resource "aws_route53_record" "catalogue" {
    zone_id = var.route53_zone
    name    = "catalogue.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.catalogue.lb_internal_dns_name
    ]    
}

resource "aws_route53_record" "search" {
    zone_id = var.route53_zone
    name    = "search.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.search.lb_internal_dns_name
    ]    
}

resource "aws_route53_record" "wagtaildocs" {
    zone_id = var.route53_zone
    name    = "wagtaildocs.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.wagtaildocs.lb_internal_dns_name
    ]    
}

