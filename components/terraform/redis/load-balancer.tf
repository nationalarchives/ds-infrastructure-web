# -----------------------------------------------------------------------------
# Internal Load Balancer
# -----------------------------------------------------------------------------
resource "aws_lb" "wagtail_redis" {
    name               = "wagtail-redis"
    internal           = true
    load_balancer_type = "application"

    security_groups = [
        var.redis_lb_id,
    ]

    subnets = [
        var.private_subnet_a_id,
        var.private_subnet_b_id
    ]

    tags = var.tags
}

resource "aws_lb_target_group" "wagtail_redis" {
    name     = "wagtail-redis"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
    }

    tags = var.tags
}

resource "aws_lb_listener" "internal_http" {
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.wagtail_redis.arn
    }
    protocol          = "HTTP"
    load_balancer_arn = aws_lb.wagtail_redis.arn
    port              = 80
}
