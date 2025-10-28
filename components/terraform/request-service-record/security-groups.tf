resource "aws_security_group" "request_service_record" {
    name        = "request-service-record"
    description = "access to application"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "request-service-record"
    })
}

resource "aws_security_group_rule" "request_service_record" {
    description              = "port 80 traffic from LB"
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.request_service_record.id
    source_security_group_id = var.lb_security_group_id
    to_port                  = 80
    type                     = "ingress"
}

resource "aws_security_group_rule" "request_service_record_response_ingress" {
    cidr_blocks       = var.instance_cidr
    description       = "traffic from Client-VPN and load balancer"
    from_port         = 1024
    protocol          = "tcp"
    security_group_id = aws_security_group.request_service_record.id
    to_port           = 65535
    type              = "ingress"
}

resource "aws_security_group_rule" "request_service_record_http_egress" {
    security_group_id = aws_security_group.request_service_record.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}
