# -----------------------------------------------------------------------------
# application servers Wagtail
# -----------------------------------------------------------------------------
# load balancer
#
resource "aws_security_group" "wagtail_lb" {
    name        = "wagtail-lb"
    description = "Reverse Proxy Security Group HTTP access"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "wagtail-lb"
    })
}

resource "aws_security_group_rule" "wagtail_lb_http_ingress" {
    cidr_blocks       = var.wagtail_lb_cidr
    description       = "port 80 traffic from RPs"
    from_port         = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.wagtail_lb.id
    to_port           = 80
    type              = "ingress"
}

resource "aws_security_group_rule" "wagtail_lb_http_egress" {
    security_group_id = aws_security_group.wagtail_lb.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
}

# instance
#
resource "aws_security_group" "wagtail" {
    name        = "wagtail"
    description = "access to Wagtail application"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "wagtail"
    })
}

resource "aws_security_group_rule" "wagtail_http_ingress" {
    description              = "port 80 traffic from LB"
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.wagtail.id
    source_security_group_id = aws_security_group.wagtail_lb.id
    to_port                  = 80
    type                     = "ingress"
}

resource "aws_security_group_rule" "wagtail_response_ingress" {
    cidr_blocks       = var.wagtail_instance_cidr
    description       = "traffic from Client-VPN and load balancer"
    from_port         = 1024
    protocol          = "tcp"
    security_group_id = aws_security_group.wagtail.id
    to_port           = 65535
    type              = "ingress"
}

resource "aws_security_group_rule" "wagtail_http_egress" {
    security_group_id = aws_security_group.wagtail.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}