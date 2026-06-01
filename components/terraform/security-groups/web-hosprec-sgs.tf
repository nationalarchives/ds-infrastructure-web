# -----------------------------------------------------------------------------
# application servers Hosprec
# -----------------------------------------------------------------------------
resource "aws_security_group" "web_hosprec" {
    name        = "web-hosprec"
    description = "access to hosprec application"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-hosprec"
    })
}

resource "aws_security_group_rule" "web_hosprec_http_ingress" {
    description              = "port 80 traffic from LB"
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.web_hosprec.id
    source_security_group_id = var.lb_security_group_id
    to_port                  = 80
    type                     = "ingress"
}

resource "aws_security_group_rule" "web_hosprec_response_ingress" {
    cidr_blocks       = var.instance_cidr
    description       = "traffic from Client-VPN and load balancer"
    from_port         = 1024
    protocol          = "tcp"
    security_group_id = aws_security_group.web_hosprec.id
    to_port           = 65535
    type              = "ingress"
}

resource "aws_security_group_rule" "web_hosprec_http_egress" {
    security_group_id = aws_security_group.web_hosprec.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}
