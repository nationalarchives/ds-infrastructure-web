resource "aws_route53_record" "web-frontend" {
    zone_id = var.route53_zone                                # change later
    name    = "web-frontend.${var.environment}.local"
    type    = "CNAME"
    ttl     = 300

    records = [
         module.frontend.lb_internal_dns_name
    ]
}

