output "ec2_mount_efs_sg_id" {
    value = aws_security_group.ec2_mount_media_efs.id
}

output "upload_efs_sg_id" {
    value = aws_security_group.upload_efs.id
}

output "lambda_web_deployment_id" {
    value = aws_security_group.lambda_web_deployment.id
}


output "web_catalogue_sg_id" {
    value = aws_security_group.web_catalogue.id
}
output "web_enrichment_sg_id" {
    value = aws_security_group.web_enrichment.id
}
output "redis_sg_id" {
   value = aws_security_group.redis.id
}
output "web_request_service_record_sg_id" {
    value = aws_security_group.web_request_service_record.id
}
output "web_search_sg_id" {
    value = aws_security_group.web_search.id
}
output "web_wagtail_sg_id" {
    value = aws_security_group.web_wagtail.id
}
output "web_wagtaildocs_sg_id" {
    value = aws_security_group.web_wagtaildocs.id
}
