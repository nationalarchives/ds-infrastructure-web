# -----------------------------------------------------------------------------
# application servers reverse proxy
# -----------------------------------------------------------------------------
resource "aws_security_group" "web_reverse_proxy" {
    name        = "web-reverse-proxy"
    description = "access to reverse proxy application"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-reverse-proxy"
    })
}

# resource "aws_security_group" "web_reverse_proxy_lb" {
#   name   = "web-reverse-proxy-lb"
#   vpc_id = var.vpc_id
# }

resource "aws_security_group_rule" "web_reverse_proxy_http_ingress" {
    description              = "port 80 traffic from LB"
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.web_reverse_proxy.id
    source_security_group_id = aws_security_group.web_reverse_proxy.id
    to_port                  = 80
    type                     = "ingress"
}

resource "aws_security_group_rule" "web_reverse_proxy_https_ingress" {
    from_port         = 443
    protocol          = "tcp"
    security_group_id = aws_security_group.web_reverse_proxy.id
    to_port           = 443
    type              = "ingress"
    cidr_blocks       = [
        "0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_reverse_proxy_response_ingress" {
    cidr_blocks       = var.instance_cidr
    description       = "traffic from Client-VPN and load balancer"
    from_port         = 1024
    protocol          = "tcp"
    security_group_id = aws_security_group.web_reverse_proxy.id
    to_port           = 65535
    type              = "ingress"
}

resource "aws_security_group_rule" "web_reverse_proxy_http_egress" {
    security_group_id = aws_security_group.web_reverse_proxy.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}
