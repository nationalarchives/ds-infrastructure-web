resource "aws_lb_target_group" "web_enrichment" {
    name     = "web-enrichment"
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

resource "aws_lb_listener_rule" "x_target_header_routing" {
    listener_arn = var.lb_listener_arn
    priority     = 40

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.web_enrichment.arn
    }

    condition {
        http_header {
            http_header_name = "x-target"
            values = [var.x_target_header]
        }
    }
}
resource "aws_lb_listener_rule" "host_based_routing" {
    listener_arn = var.lb_listener_arn
    priority     = 45

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.web_enrichment.arn
    }

    condition {
        host_header {
            values = [var.host_header]
        }
    }
}
