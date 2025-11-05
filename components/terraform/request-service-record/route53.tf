resource "aws_route53_record" "web_rsr_cname" {
    zone_id = var.route53_zone
    name    = "web-rsr.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        var.lb_name
    ]
}
