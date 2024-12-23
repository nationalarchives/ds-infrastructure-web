# -----------------------------------------------------------------------------
# reverse proxy
# -----------------------------------------------------------------------------
# load balancer
#
resource "aws_security_group" "rp_lb_web" {                     #changed to web
    name        = "web-rp-lb"                                   #changed to web
    description = "reverse proxy HTTP and HTTPS access"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-rp-lb"
    })
}

resource "aws_security_group_rule" "rp_lb_web_http_ingress" {            #changed to web
    cidr_blocks       = ["0.0.0.0/0"]
    description       = "port 80 will be redirected to 443"
    from_port         = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.rp_lb_web.id                  #changed to web
    to_port           = 80
    type              = "ingress"
}

resource "aws_security_group_rule" "rp_lb_web_https_ingress" {           #changed to web
    cidr_blocks       = ["0.0.0.0/0"]
    description       = "443 traffic from anywhere"
    from_port         = 443
    protocol          = "tcp"
    security_group_id = aws_security_group.rp_lb_web.id                 #changed to web
    to_port           = 443
    type              = "ingress"
}

resource "aws_security_group_rule" "rp_lb_web_http_egress" {            #changed to web
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.rp_lb_web.id                 #changed to web
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
}

# instance
#
resource "aws_security_group" "rp_web" {                                #changed to web
    name        = "web-rp"                                               #changed to web
    description = "Reverse proxy security group"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-rp"                                                  #changed to web
    })
}

resource "aws_security_group_rule" "rp_web_http_ingress" {                 #changed to web
    description              = "port 80 traffic from LB"
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.rp_web.id              #changed to web
    source_security_group_id = aws_security_group.rp_lb_web.id              #changed to web
    type                     = "ingress"
}

resource "aws_security_group_rule" "rp_response_web_ingress" {                #changed to web
    cidr_blocks       = var.rp_instance_cidr
    description       = "allow response from internal subnets"
    from_port         = 1024
    to_port           = 65535
    protocol          = "tcp"
    security_group_id = aws_security_group.rp_web.id                   #changed to web
    type              = "ingress"
}

resource "aws_security_group_rule" "rp_web_egress" {                      #changed to web
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    security_group_id = aws_security_group.rp_web.id                      #changed to web
    type              = "egress"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}
