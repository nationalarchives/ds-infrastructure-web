# load balancer
#
resource "aws_security_group" "frontend_lb" {
    name        = "request-service-record-lb"
    description = "Reverse Proxy Security Group HTTP access"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "request-service-record-lb"
    })
}

resource "aws_security_group_rule" "frontend_lb_http_ingress" {
    cidr_blocks       = var.lb_cidr
    description       = "port 80 traffic from RPs"
    from_port         = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.frontend_lb.id
    to_port           = 80
    type              = "ingress"
}

resource "aws_security_group_rule" "frontend_lb_http_egress" {
    security_group_id = aws_security_group.frontend_lb.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
}

# instance
#
resource "aws_security_group" "frontend" {
    name        = "request-service-record"
    description = "access to application"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "request-service-record"
    })
}

resource "aws_security_group_rule" "frontend_http_ingress" {
    description              = "port 80 traffic from LB"
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.frontend.id
    source_security_group_id = aws_security_group.frontend_lb.id
    to_port                  = 80
    type                     = "ingress"
}

resource "aws_security_group_rule" "frontend_response_ingress" {
    cidr_blocks       = var.instance_cidr
    description       = "traffic from Client-VPN and load balancer"
    from_port         = 1024
    protocol          = "tcp"
    security_group_id = aws_security_group.frontend.id
    to_port           = 65535
    type              = "ingress"
}

resource "aws_security_group_rule" "frontend_http_egress" {
    security_group_id = aws_security_group.frontend.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}
