resource "aws_ssm_parameter" "nginx_conf_efs_dns_name" {          
    name  = "/infrastructure/nginx-efs/efs-dns-name"    
    type  = "String"    
    value = aws_efs_file_system.nginx_efs.dns_name
}
