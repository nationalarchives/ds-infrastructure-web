resource "aws_lb_target_group" "wagtail" {
    name     = "wagtail"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        interval            = 30
        path                = "/healthcheck/"
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
        target_group_arn = aws_lb_target_group.wagtail.arn
    }
    protocol          = "HTTP"
    load_balancer_arn = var.lb_arn
    port              = 81

    routing_http_response_access_control_allow_origin_header_value = var.origin_header
}
