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
        target_group_arn = aws_lb_target_group.request_service_record.arn
    }
    protocol          = "HTTP"
    load_balancer_arn = var.lb_arn
    port              = 80

    routing_http_response_access_control_allow_origin_header_value = var.origin_header
}
