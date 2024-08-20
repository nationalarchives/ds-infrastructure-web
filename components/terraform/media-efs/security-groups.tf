resource "aws_security_group" "media_efs" {
    name        = "web-media-efs"
    description = "ec2 access to media efs"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-media-efs"
    })
}

resource "aws_security_group_rule" "media_mount_efs_ingress" {
    description              = "efs mount target"
    from_port                = 2049
    protocol                 = "tcp"
    security_group_id        = aws_security_group.media_efs.id
    to_port                  = 2049
    type                     = "egress"
    source_security_group_id = aws_security_group.media_efs.id
}
