# -----------------------------------------------------------------------------
# postgre db
# -----------------------------------------------------------------------------
# instance
#
resource "aws_security_group" "postgre" {
    name        = "beta-postgre"
    description = "Reverse proxy security group"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "beta-postgre"
    })
}

resource "aws_security_group_rule" "postgre_ingress" {
    cidr_blocks       = var.db_instance_cidr
    description       = "allow response from internal subnets"
    from_port         = 5432
    to_port           = 5432
    protocol          = "tcp"
    security_group_id = aws_security_group.postgre.id
    type              = "ingress"
}

resource "aws_security_group_rule" "postgre_egress" {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    security_group_id = aws_security_group.postgre.id
    type              = "egress"
    cidr_blocks       = [
        "0.0.0.0/0"
    ]
}
