variable "public_domain" {}
variable "private_record" {}
variable "db_record" {}

# Public domain name (reverse proxy) and alias to reverse proxy instance
#
resource "aws_route53_zone" "reverse_proxy_public" {
    name  = var.public_domain

    tags = local.tags
}

resource "aws_route53_record" "reverse_proxy_public" {
    zone_id = aws_route53_zone.reverse_proxy_public.zone_id
    name    = var.public_domain
    type    = "A"

    alias {
        name                   = module.cloudfront_public.cloudfront_dns
        zone_id                = module.cloudfront_public.cloudfront_zone_id
        evaluate_target_health = false
    }
}

# Private zone CNAME record for Django/Wagtail load balancer
#
resource "aws_route53_record" "dw-app" {
    zone_id = data.aws_ssm_parameter.zone_id.value
    name    = "beta.${var.environment}.local"
    type    = "CNAME"
    ttl     = 15

    records = [
        module.django-wagtail.lb_internal_dns_name
    ]
}

