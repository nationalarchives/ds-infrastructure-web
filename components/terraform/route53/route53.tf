resource "aws_route53_zone" "user_pool" {
    name = var.user_pool_domain
}

resource "aws_route53_record" "user_pool" {
    zone_id = aws_route53_zone.user_pool.zone_id
    name    = var.user_pool_domain
    type    = "A"
    alias {
        evaluate_target_health = false

        name    = var.cloudfront_distribution
        zone_id = var.cloudfront_distribution_zone_id
    }
}