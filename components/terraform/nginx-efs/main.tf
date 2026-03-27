resource "aws_efs_file_system" "nginx_efs" {
  creation_token = "web-nginx-efs"
    encrypted      = true

  tags = merge(var.tags, {
    Name        = "web-nginx-efs"
    
  })
}

resource "aws_efs_mount_target" "nginx_efs_private_sub" {
  for_each = tomap({ for idx, value in var.private_subs : idx => value })

  file_system_id = aws_efs_file_system.nginx_efs.id
  subnet_id      = each.value

  security_groups = [
    aws_security_group.nginx_efs.id,
  ]
}