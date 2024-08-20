# security groups for conf efs
# need to be attached to EC@ and EFS allowing coms over port 2049
#
resource "aws_security_group" "rp_nginx_confs_efs" {
    name        = "web-rp-nginx-confs-efs"
    description = "ec2 access to rp nginx conf efs"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-rp-nginx-confs-efs"
    })
}

resource "aws_security_group_rule" "rp_nginx_confs_mount_efs_ingress" {
    description              = "efs mount target"
    from_port                = 2049
    protocol                 = "tcp"
    security_group_id        = aws_security_group.rp_nginx_confs_efs.id
    to_port                  = 2049
    type                     = "egress"
    source_security_group_id = aws_security_group.rp_nginx_confs_efs.id
}
