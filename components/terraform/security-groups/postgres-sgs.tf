# -----------------------------------------------------------------------------
# postgre db
# -----------------------------------------------------------------------------
# instance
#
resource "aws_security_group" "postgre_web" {             #changed to web
    name        = "web-postgre"                           #changed to web
    description = "Reverse proxy security group"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-postgre"                              #changed to web
    })
}

resource "aws_security_group_rule" "postgre_web_ingress" {       #changed to web
    cidr_blocks       = var.db_instance_cidr
    description       = "allow response from internal subnets"
    from_port         = 5432
    to_port           = 5432
    protocol          = "tcp"
    security_group_id = aws_security_group.postgre_web.id     #changed to web
    type              = "ingress"
}

resource "aws_security_group_rule" "postgre_web_egress" {         #changed to web
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    security_group_id = aws_security_group.postgre_web.id             #changed to web
    type              = "egress"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}
