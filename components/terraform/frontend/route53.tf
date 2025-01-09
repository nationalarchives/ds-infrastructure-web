resource "aws_route53_record" "web-frontend" {
    zone_id =
    name    = "web-frontend.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.django-wagtail.lb_internal_dns_name
    ]
}

