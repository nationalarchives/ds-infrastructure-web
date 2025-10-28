output "ec2_mount_efs_sg_id" {
    value = aws_security_group.ec2_mount_media_efs.id
}

output "upload_efs_sg_id" {
    value = aws_security_group.upload_efs.id
}

output "lambda_web_deployment_id" {
    value = aws_security_group.lambda_web_deployment.id
}


output "catalogue_sg_id" {
    value = aws_security_group.catalogue.id
}
output "enrichment_sg_id" {
    value = aws_security_group.enrichment.id
}
output "redis_sg_id" {
   value = aws_security_group.redis.id
}
output "search_sg_id" {
    value = aws_security_group.search.id
}
output "wagtail_sg_id" {
    value = aws_security_group.wagtail.id
}
output "wagtaildocs_sg_id" {
    value = aws_security_group.wagtaildocs.id
}
