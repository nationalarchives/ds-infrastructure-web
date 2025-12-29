# -----------------------------------------------------------------------------
# application servers Wagtail
# -----------------------------------------------------------------------------
resource "aws_security_group" "web_wagtail" {
    name        = "web-wagtail"
    description = "access to Wagtail application"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-wagtail"
    })
}

resource "aws_security_group_rule" "web_wagtail_http_ingress" {
    description              = "port 80 traffic from LB"
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.web_wagtail.id
    source_security_group_id = var.lb_security_group_id
    to_port                  = 80
    type                     = "ingress"
}

resource "aws_security_group_rule" "web_wagtail_response_ingress" {
    cidr_blocks       = var.instance_cidr
    description       = "traffic from Client-VPN and load balancer"
    from_port         = 1024
    protocol          = "tcp"
    security_group_id = aws_security_group.web_wagtail.id
    to_port           = 65535
    type              = "ingress"
}

resource "aws_security_group_rule" "web_wagtail_http_egress" {
    security_group_id = aws_security_group.web_wagtail.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}
