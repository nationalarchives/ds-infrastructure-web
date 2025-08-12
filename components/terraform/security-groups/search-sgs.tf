# -----------------------------------------------------------------------------
# application servers search
# -----------------------------------------------------------------------------
# load balancer
#
resource "aws_security_group" "search_lb" {
    name        = "search-lb"
    description = "Reverse Proxy Security Group HTTP access"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "search-lb"
    })
}

resource "aws_security_group_rule" "search_lb_http_ingress" {
    cidr_blocks       = var.search_lb_cidr
    description       = "port 80 traffic from RPs"
    from_port         = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.search_lb.id
    to_port           = 80
    type              = "ingress"
}

resource "aws_security_group_rule" "search_lb_http_egress" {
    security_group_id = aws_security_group.search_lb.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
}

# instance
#
resource "aws_security_group" "search" {
    name        = "search"
    description = "access to search application"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "search"
    })
}

resource "aws_security_group_rule" "search_http_ingress" {
    description              = "port 80 traffic from LB"
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.search.id
    source_security_group_id = aws_security_group.search_lb.id
    to_port                  = 80
    type                     = "ingress"
}

resource "aws_security_group_rule" "search_response_ingress" {
    cidr_blocks       = var.search_instance_cidr
    description       = "traffic from Client-VPN and load balancer"
    from_port         = 1024
    protocol          = "tcp"
    security_group_id = aws_security_group.search.id
    to_port           = 65535
    type              = "ingress"
}

resource "aws_security_group_rule" "search_http_egress" {
    security_group_id = aws_security_group.search.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}