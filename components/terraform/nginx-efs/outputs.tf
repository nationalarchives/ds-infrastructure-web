output "nginx_efs_dns_name" {
  value = aws_efs_file_system.nginx_efs.dns_name
}

output "nginx_efs_sg_id" {
  value = aws_security_group.nginx_efs.id
}