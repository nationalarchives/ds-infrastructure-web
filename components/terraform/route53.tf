variable "user_pool_domain" {}

module "etna-route53" {
    source = "./route53"

    user_pool_domain = var.user_pool_domain
    cloudfront_distribution         = module.etna-cognito.cognito_cloudfront_distribution
    cloudfront_distribution_zone_id = module.etna-cognito.cognito_cloudfront_distribution_zone_id
}
