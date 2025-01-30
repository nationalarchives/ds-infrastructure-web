output "media_efs_dns_name" {
    value = aws_efs_file_system.media_efs.dns_name
}

output "media_efs_sg_id" {
    value = aws_security_group.media_efs.id
}



