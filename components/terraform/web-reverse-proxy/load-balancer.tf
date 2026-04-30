# -----------------------------------------------------------------------------
# Public Load Balancer
# -----------------------------------------------------------------------------
resource "aws_lb" "web_reverse_proxy" {
    name               = "web-reverse-proxy"
    internal           = false
    load_balancer_type = "application"

    security_groups = [
        var.lb_sg_id
    ]

    subnets = [
        var.public_subnet_a_id,
        var.public_subnet_b_id]

    tags = var.tags
}

resource "aws_lb_target_group" "web_reverse_proxy" {
    name     = "web-reverse-proxy"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        interval            = 30
        path                = "/healthcheck/live/"
        port                = "traffic-port"
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200,301"
    }

    tags = var.tags
}

resource "aws_lb_listener" "public_http_lb_listener" {
    default_action {
        type = "redirect"
        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }
    protocol          = "HTTP"
    load_balancer_arn = aws_lb.web_reverse_proxy.arn
    port              = 80
}
# pronom - droid forwarding listener ruled allowing http access
# introduced 09/11/2021
# need revisit May 2022 and should be removed if possible
resource "aws_lb_listener_rule" "pronom_path_http" {
    listener_arn = aws_lb_listener.public_http_lb_listener.arn
    priority     = 1

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.web_reverse_proxy.arn
    }

    condition {
        path_pattern {
            values = [
                "/pronom/*",
                "/PRONOM/*"]
        }
    }
}

resource "aws_lb_listener" "public_https_lb_listener" {
    default_action {
        target_group_arn = aws_lb_target_group.web_reverse_proxy.arn
        type             = "forward"
    }

    protocol          = "HTTPS"
    load_balancer_arn = aws_lb.web_reverse_proxy.arn
    port              = 443
    ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
    certificate_arn = var.public_ssl_cert_arn
}

resource "aws_lb_listener_certificate" "sub_sub_domain" {
    listener_arn    = aws_lb_listener.public_https_lb_listener.arn
    certificate_arn = var.sub_sub_domain_ssl_cert_arn
}
