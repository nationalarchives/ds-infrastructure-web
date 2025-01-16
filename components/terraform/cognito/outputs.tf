output "cognito_pool_arn" {
    value = aws_cognito_user_pool.cognito_user_pool.arn
}

output "cognito_user_pool_id" {
    value = aws_cognito_user_pool.cognito_user_pool.id
}

output "cognito_client_id" {
    value = aws_cognito_user_pool_client.user_pool_client.id
}

output "cognito_client_secret" {
    value = aws_cognito_user_pool_client.user_pool_client.client_secret
}

output "cognito_cloudfront_distribution" {
    value = aws_cognito_user_pool_domain.user_pool.cloudfront_distribution
}

output "cognito_cloudfront_distribution_zone_id" {
    value = aws_cognito_user_pool_domain.user_pool.cloudfront_distribution_zone_id
}
