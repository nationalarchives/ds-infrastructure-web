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
