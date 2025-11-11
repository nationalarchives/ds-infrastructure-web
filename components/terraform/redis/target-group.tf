resource "aws_lb_target_group" "platform_redis" {
    name     = "platform-redis"
    port     = 50
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

resource "aws_lb_listener_rule" "host_based_routing" {
    listener_arn = var.lb_listener_arn
    priority     = 55

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.platform_redis.arn
    }

    condition {
        http_header {
            http_header_name = "x-target"
            values = [var.x_target_header]
        }
    }
}
