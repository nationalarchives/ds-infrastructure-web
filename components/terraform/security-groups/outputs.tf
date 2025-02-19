output "ec2_mount_efs_sg_id" {
    value = aws_security_group.ec2_mount_media_efs.id
}

output "rp_sg_id" {
    value = aws_security_group.rp.id
}
output "rp_lb_sg_id" {
    value = aws_security_group.rp_lb.id
}

output "upload_efs_sg_id" {
    value = aws_security_group.upload_efs.id
}

output "lambda_web_deployment_id" {
    value = aws_security_group.lambda_web_deployment.id
}

output "wagtail_sg_id" {
    value = aws_security_group.wagtail.id
}

output "wagtail_lb_id" {
    value = aws_security_group.wagtail_lb.id
}

output "wagtail_lb" {
    value = aws_security_group.wagtail_lb.id
}

output "enrichment_lb_id" {
   value = aws_security_group.enrichment_lb.id
}
output "enrichment_sg_id" {
   value = aws_security_group.enrichment.id
}
