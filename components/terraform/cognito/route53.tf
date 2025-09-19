resource "aws_route53_zone" "user_pool" {
    name = var.user_pool_domain
}

resource "aws_route53_record" "user_pool" {
    zone_id = aws_route53_zone.user_pool.zone_id
    name    = var.user_pool_domain
    type    = "A"
    alias {
        evaluate_target_health = false

        name    = aws_cognito_user_pool_domain.user_pool.cloudfront_distribution
        zone_id = aws_cognito_user_pool_domain.user_pool.cloudfront_distribution_zone_id
    }
}
