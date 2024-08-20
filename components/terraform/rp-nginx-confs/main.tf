resource "aws_s3_object" "nginx_conf" {
    bucket = var.deployment_s3_bucket
    key    = "${var.s3_deployment_runtime_key}/nginx.conf"
    content = templatefile("${path.module}/scripts/nginx.conf", {
        account  = var.account,
        resolver = var.resolver
    })
}

resource "aws_s3_object" "cloudfront_ips_conf" {
    bucket = var.deployment_s3_bucket
    key    = "${var.s3_deployment_runtime_key}/cloudfront_ips.conf"
    source = "${path.module}/scripts/cloudfront_ips.conf"
    source_hash = filemd5("${path.module}/scripts/cloudfront_ips.conf")
}

resource "aws_s3_object" "nginx_logrotate" {
    bucket = var.deployment_s3_bucket
    key    = "${var.s3_deployment_runtime_key}/nginx"
    source = "${path.module}/scripts/nginx"
    source_hash = filemd5("${path.module}/scripts/nginx")
}

resource "aws_s3_object" "update_nginx_confs" {
    bucket = var.deployment_s3_bucket
    key    = "${var.s3_deployment_runtime_key}/update_nginx_confs.sh"
    content = templatefile("${path.module}/scripts/update_nginx_confs.sh", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        s3_key               = var.s3_deployment_runtime_key
    })
}
