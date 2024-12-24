# -----------------------------------------------------------------------------
# reverse proxy
# -----------------------------------------------------------------------------
# load balancer
#
resource "aws_security_group" "rp_lb" {
    name        = "beta-rp-lb"
    description = "reverse proxy HTTP and HTTPS access"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "beta-rp-lb"
    })
}

resource "aws_security_group_rule" "rp_lb_http_ingress" {
    cidr_blocks       = ["0.0.0.0/0"]
    description       = "port 80 will be redirected to 443"
    from_port         = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.rp_lb.id
    to_port           = 80
    type              = "ingress"
}

resource "aws_security_group_rule" "rp_lb_https_ingress" {
    cidr_blocks       = ["0.0.0.0/0"]
    description       = "443 traffic from anywhere"
    from_port         = 443
    protocol          = "tcp"
    security_group_id = aws_security_group.rp_lb.id
    to_port           = 443
    type              = "ingress"
}

resource "aws_security_group_rule" "rp_lb_http_egress" {
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.rp_lb.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
}

# instance
#
resource "aws_security_group" "rp" {
    name        = "beta-rp"
    description = "Reverse proxy security group"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "beta-rp"
    })
}

resource "aws_security_group_rule" "rp_http_ingress" {
    description              = "port 80 traffic from LB"
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.rp.id
    source_security_group_id = aws_security_group.rp_lb.id
    type                     = "ingress"
}

resource "aws_security_group_rule" "rp_response_ingress" {
    cidr_blocks       = var.rp_instance_cidr
    description       = "allow response from internal subnets"
    from_port         = 1024
    to_port           = 65535
    protocol          = "tcp"
    security_group_id = aws_security_group.rp.id
    type              = "ingress"
}

resource "aws_security_group_rule" "rp_egress" {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    security_group_id = aws_security_group.rp.id
    type              = "egress"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}
