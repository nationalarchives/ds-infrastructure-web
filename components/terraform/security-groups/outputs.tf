output "ec2_mount_efs_sg_id" {
    value = aws_security_group.ec2_mount_media_efs.id
}

output "media_efs_sg_id" {
    value = aws_security_group.media_efs.id
}

output "dw_lb_sg_id" {
    value = aws_security_group.dw_lb_web.id
}
output "dw_sg_id" {
    value = aws_security_group.dw_web.id
}

output "rp_sg_id" {
    value = aws_security_group.rp_web.id        #changed to web
}
output "rp_lb_sg_id" {
    value = aws_security_group.rp_lb_web.id       #changed to web
}

output "upload_efs_sg_id" {
    value = aws_security_group.upload_efs.id
}

output "lambda_beta_deployment_id" {
    value = aws_security_group.lambda_beta_deployment.id
}
