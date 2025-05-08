output "lb_internal_dns_name" {
    value = aws_lb.platform_redis.dns_name
}

output "redis_lb_id" {
    value = aws_lb.platform_redis.id
}
