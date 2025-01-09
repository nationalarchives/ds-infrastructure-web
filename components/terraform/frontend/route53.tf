resource "aws_route53_record" "web-frontend" {
    zone_id = var.route53_zone
    name    = "web-frontend.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        aws_lb.web_frontend.dns_name
    ]
}

