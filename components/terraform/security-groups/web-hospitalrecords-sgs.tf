# -----------------------------------------------------------------------------
# application servers hospitalrecords
# -----------------------------------------------------------------------------
resource "aws_security_group" "web_hospitalrecords" {
    name        = "web-hospitalrecords"
    description = "access to hospitalrecords application"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-hospitalrecords"
    })
}

resource "aws_security_group_rule" "web_hospitalrecords_http_ingress" {
    description              = "port 80 traffic from LB"
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.web_hospitalrecords.id
    source_security_group_id = var.lb_security_group_id
    to_port                  = 80
    type                     = "ingress"
}

resource "aws_security_group_rule" "web_hospitalrecords_response_ingress" {
    cidr_blocks       = var.instance_cidr
    description       = "traffic from Client-VPN and load balancer"
    from_port         = 1024
    protocol          = "tcp"
    security_group_id = aws_security_group.web_hospitalrecords.id
    to_port           = 65535
    type              = "ingress"
}

resource "aws_security_group_rule" "web_hospitalrecords_http_egress" {
    security_group_id = aws_security_group.web_hospitalrecords.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}
