# -----------------------------------------------------------------------------
# Internal Load Balancer
# -----------------------------------------------------------------------------
resource "aws_lb" "web_frontend" {
    name               = "web-frontend"
    internal           = true
    load_balancer_type = "application"

    security_groups = [
        aws_security_group.frontend_lb.id,
    ]

    subnets = [
        var.private_subnet_a_id,
        var.private_subnet_b_id
    ]

    tags = var.tags
}

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
    load_balancer_arn = aws_lb.web_frontend.arn
    port              = 80
}
