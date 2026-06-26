# -----------------------------------------------------------------------------
# application servers Bulkdownload
# -----------------------------------------------------------------------------
resource "aws_security_group" "web_bulkdownload" {
    count = var.environment == "live" ? 1 : 0

    name        = "web-bulkdownload"
    description = "access to bulkdownload application"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-bulkdownload"
    })
}

resource "aws_security_group_rule" "web_bulkdownload_http_ingress" {
    count = var.environment == "live" ? 1 : 0

    description              = "port 80 traffic from LB"
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.web_bulkdownload[0].id
    source_security_group_id = var.lb_security_group_id
    to_port                  = 80
    type                     = "ingress"
}

resource "aws_security_group_rule" "web_bulkdownload_response_ingress" {
    count = var.environment == "live" ? 1 : 0

    cidr_blocks       = var.instance_cidr
    description       = "traffic from Client-VPN and load balancer"
    from_port         = 1024
    protocol          = "tcp"
    security_group_id = aws_security_group.web_bulkdownload[0].id
    to_port           = 65535
    type              = "ingress"
}

resource "aws_security_group_rule" "web_bulkdownload_http_egress" {
    count = var.environment == "live" ? 1 : 0

    security_group_id = aws_security_group.web_bulkdownload[0].id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"

    cidr_blocks = [
        "0.0.0.0/0"
    ]
}
