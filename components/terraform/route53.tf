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

resource "aws_route53_record" "web_wagtail" {
    zone_id = var.route53_zone
    name    = "web-wagtail.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.load-balancer.load_balancer_dns_name
    ]
}

resource "aws_route53_record" "web-catalogue" {
    zone_id = var.route53_zone
    name    = "web-catalogue.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.load-balancer.load_balancer_dns_name
    ]
}

resource "aws_route53_record" "web_search" {
    zone_id = var.route53_zone
    name    = "web-search.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.load-balancer.load_balancer_dns_name
    ]
}

resource "aws_route53_record" "web_wagtaildocs" {
    zone_id = var.route53_zone
    name    = "web-wagtaildocs.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.load-balancer.load_balancer_dns_name
    ]
}

resource "aws_route53_record" "web_forms" {
    zone_id = var.route53_zone
    name    = "web-forms.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.load-balancer.load_balancer_dns_name
    ]
}
