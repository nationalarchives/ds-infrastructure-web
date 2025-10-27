resource "aws_lb_target_group" "web_frontend" {
    name     = "web-frontend"
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
        target_group_arn = aws_lb_target_group.web_frontend.arn
    }
    protocol          = "HTTP"
    load_balancer_arn = var.lb_arn
    port              = 80
}

resource "aws_lb_listener_rule" "host_based_routing" {
    listener_arn = aws_lb_listener.internal_http.arn
    priority     = 20

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.web_frontend.arn
    }

    condition {
        host_header {
            values = [
                var.origin_header
            ]
        }
    }
}
