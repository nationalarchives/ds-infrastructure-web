# -----------------------------------------------------------------------------
# application servers redis
# -----------------------------------------------------------------------------
# load balancer
#
resource "aws_security_group" "redis_lb" {
    name        = "platform-redis-lb"
    description = "Reverse Proxy Security Group HTTP access"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "platform-redis-lb"
    })
}

resource "aws_security_group_rule" "redis_lb_http_ingress" {
    cidr_blocks       = var.redis_lb_cidr
    description       = "port 80 traffic from RPs"
    from_port         = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.redis_lb.id
    to_port           = 80
    type              = "ingress"
}

resource "aws_security_group_rule" "redis_lb_http_egress" {
    security_group_id = aws_security_group.redis_lb.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
}

# instance
#
resource "aws_security_group" "redis" {
    name        = "platform-redis"
    description = "access to application"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "platform-redis"
    })
}

resource "aws_security_group_rule" "redis_http_ingress" {
    description              = "port 80 traffic from LB"
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.redis.id
    source_security_group_id = aws_security_group.redis_lb.id
    to_port                  = 80
    type                     = "ingress"
}

resource "aws_security_group_rule" "redis_response_ingress" {
    cidr_blocks       = var.redis_instance_cidr
    description       = "traffic from Client-VPN and load balancer"
    from_port         = 1024
    protocol          = "tcp"
    security_group_id = aws_security_group.redis.id
    to_port           = 65535
    type              = "ingress"
}

resource "aws_security_group_rule" "redis_http_egress" {
    security_group_id = aws_security_group.redis.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}