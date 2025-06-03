resource "aws_ssm_parameter" "wagtail_efs_media_dns_name" {          
    name  = "/infrastructure/wagtail-efs/media-dns-name"    
    type  = "String"    
    value = aws_efs_file_system.media_efs.dns_name
}
