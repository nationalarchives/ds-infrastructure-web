output "cloudfront_dns" {
  value = aws_cloudfront_distribution.web.domain_name
}

output "cloudfront_zone_id" {
  value = aws_cloudfront_distribution.web.hosted_zone_id
}
