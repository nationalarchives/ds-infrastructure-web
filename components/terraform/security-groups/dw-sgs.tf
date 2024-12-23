# -----------------------------------------------------------------------------
# application servers Django/Wagtail
# -----------------------------------------------------------------------------
# load balancer
#
resource "aws_security_group" "dw_lb_web" {
    name        = "web-dw-lb"
    description = "Reverse Proxy Security Group HTTP access"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-dw-lb"
    })
}

resource "aws_security_group_rule" "dw_lb_web_http_ingress" {
    cidr_blocks       = var.dw_lb_cidr
    description       = "port 80 traffic from RPs"
    from_port         = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.dw_lb_web.id
    to_port           = 80
    type              = "ingress"
}

resource "aws_security_group_rule" "dw_lb_web_http_egress" {
    security_group_id = aws_security_group.dw_lb_web.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
}

# instance
#
resource "aws_security_group" "dw_web" {
    name        = "web-dw"
    description = "access to application"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-dw"
    })
}

resource "aws_security_group_rule" "dw_web_http_ingress" {
    description              = "port 80 traffic from LB"
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.dw_web.id
    source_security_group_id = aws_security_group.dw_lb_web.id
    to_port                  = 80
    type                     = "ingress"
}

resource "aws_security_group_rule" "dw_web_response_ingress" {
    cidr_blocks       = var.dw_instance_cidr
    description       = "traffic from Client-VPN and load balancer"
    from_port         = 1024
    protocol          = "tcp"
    security_group_id = aws_security_group.dw_web.id
    to_port           = 65535
    type              = "ingress"
}

resource "aws_security_group_rule" "dw_web_http_egress" {
    security_group_id = aws_security_group.dw_web.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}
