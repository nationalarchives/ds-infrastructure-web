# share configuration files between reverse proxies
# no backup as data is easily recreated
#
resource "aws_efs_file_system" "conf_efs" {
    creation_token = "web-rp-nginx-confs-efs"
    encrypted      = true

    tags = merge(var.tags, {
        Name = "web-rp-nginx-confs-efs"
    })
}

resource "aws_efs_mount_target" "conf_efs_private_sub" {
    for_each = tomap({ for idx, value in var.private_subs : idx => value })

    file_system_id = aws_efs_file_system.conf_efs.id
    subnet_id      = each.value

    security_groups = [
        aws_security_group.rp_nginx_confs_efs.id,
    ]
}

