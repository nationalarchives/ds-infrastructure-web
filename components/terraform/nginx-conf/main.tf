resource "aws_s3_object" "nginx_conf" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/nginx.conf"
  content = templatefile("${path.module}/scripts/${var.nginx_version}/nginx.conf", {
    environment      = var.environment,
    set_real_ip_from = var.set_real_ip_from,
    resolver         = var.resolver,
  })
}

resource "aws_s3_object" "cloudfront_ips_conf" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/cloudfront_ips.conf"
  source = "${path.module}/scripts/${var.nginx_version}/cloudfront_ips.conf"
  source_hash = filemd5("${path.module}/scripts/${var.nginx_version}/cloudfront_ips.conf")
}

resource "aws_s3_object" "redirects_conf" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/redirects.conf"
  source = "${path.module}/scripts/${var.nginx_version}/redirects.conf"
  source_hash = filemd5("${path.module}/scripts/${var.nginx_version}/redirects.conf")
}

resource "aws_s3_object" "mime_types" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/mime.types"
  source = "${path.module}/scripts/${var.nginx_version}/mime.types"
  source_hash = filemd5("${path.module}/scripts/${var.nginx_version}/mime.types")
}

resource "aws_s3_object" "update_nginx_confs" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/update_nginx_confs.sh"
  content = templatefile("${path.module}/scripts/${var.nginx_version}/update_nginx_confs.sh", {
    deployment_s3_bucket = var.deployment_s3_bucket,
    nginx_folder_s3_key  = var.nginx_folder_s3_key,
    service              = var.service,
    nginx_version        = var.nginx_version
  })
}

resource "aws_s3_object" "variables_conf" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/variables.conf"
  content = templatefile("${path.module}/scripts/${var.nginx_version}/variables.conf", {
    environment      = var.environment,
    set_real_ip_from = var.set_real_ip_from,
    resolver         = var.resolver
  })
}

resource "aws_s3_object" "wagtail_admin_conf" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/wagtail_admin.conf"
  content = templatefile("${path.module}/scripts/${var.nginx_version}/wagtail_admin.conf", {
    environment      = var.environment,
    set_real_ip_from = var.set_real_ip_from
  })
}

resource "aws_s3_object" "whitelist_conf" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/whitelist.conf"
  content = templatefile("${path.module}/scripts/${var.nginx_version}/whitelist.conf", {
    environment      = var.environment,
    set_real_ip_from = var.set_real_ip_from,
    resolver         = var.resolver
  })
}