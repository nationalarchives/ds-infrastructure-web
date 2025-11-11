resource "aws_route53_record" "web-frontend" {
    zone_id = var.route53_zone
    name    = "web-frontend.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
         module.load-balancer.load_balancer_dns_name
    ]
}

resource "aws_route53_record" "web-enrichment" {
    zone_id = var.route53_zone
    name    = "web-enrichment.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.load-balancer.load_balancer_dns_name
    ]
}

resource "aws_route53_record" "wagtail" {
    zone_id = var.route53_zone
    name    = "wagtail.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.load-balancer.load_balancer_dns_name
    ]
}

resource "aws_route53_record" "catalogue" {
    zone_id = var.route53_zone
    name    = "catalogue.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.load-balancer.load_balancer_dns_name
    ]
}

resource "aws_route53_record" "search" {
    zone_id = var.route53_zone
    name    = "search.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.load-balancer.load_balancer_dns_name
    ]
}

resource "aws_route53_record" "wagtaildocs" {
    zone_id = var.route53_zone
    name    = "wagtaildocs.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.load-balancer.load_balancer_dns_name
    ]
}

