resource "aws_s3_object" "nginx_conf" {
    bucket = var.deployment_s3_bucket
    key    = "${var.service}/${var.nginx_folder_s3_key}/nginx.conf"
    content = templatefile("${path.module}/scripts/nginx.conf", {
        environment            = var.environment,
        set_real_ip_from       = var.set_real_ip_from,
        resolver               = var.resolver,
    })
}

# resource "aws_s3_object" "redirects_conf" {
#     bucket = var.deployment_s3_bucket
#     key    = "${var.service}/${var.nginx_folder_s3_key}/redirects.conf"
#     source = "${path.module}/scripts/redirects.conf"
#     source_hash = filemd5("${path.module}/scripts/redirects.conf")
# }


resource "aws_s3_object" "cloudfront_ips_conf" {
    bucket = var.deployment_s3_bucket
    key    = "${var.service}/${var.nginx_folder_s3_key}/cloudfront_ips.conf"
    source = "${path.module}/scripts/cloudfront_ips.conf"
    source_hash = filemd5("${path.module}/scripts/cloudfront_ips.conf")
}

resource "aws_s3_object" "mime_types" {
    bucket = var.deployment_s3_bucket
    key    = "${var.service}/${var.nginx_folder_s3_key}/mime.types"
    source = "${path.module}/scripts/mime.types"
    source_hash = filemd5("${path.module}/scripts/mime.types")
}

resource "aws_s3_object" "update_nginx_confs" {
    bucket = var.deployment_s3_bucket
    key    = "${var.service}/${var.nginx_folder_s3_key}/update_nginx_confs.sh"
    content = templatefile("${path.module}/scripts/update_nginx_confs.sh", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        nginx_folder_s3_key  = var.nginx_folder_s3_key,
        service              = var.service
    })
}

resource "aws_s3_object" "variables_conf" {
    bucket = var.deployment_s3_bucket
    key    = "${var.service}/${var.nginx_folder_s3_key}/variables.conf"
    content = templatefile("${path.module}/scripts/variables.conf", {
        environment          = var.environment,
        set_real_ip_from     = var.set_real_ip_from,
        resolver             = var.resolver
    })
}

resource "aws_s3_object" "wagtail_admin_conf" {
    bucket = var.deployment_s3_bucket
    key    = "${var.service}/${var.nginx_folder_s3_key}/wagtail_admin.conf"
    content = templatefile("${path.module}/scripts/wagtail_admin.conf", {
        environment      = var.environment,
        set_real_ip_from     = var.set_real_ip_from
    })

}

resource "aws_s3_object" "whitelist_conf" {
    bucket = var.deployment_s3_bucket
    key    = "${var.service}/${var.nginx_folder_s3_key}/whitelist.conf"
    content = templatefile("${path.module}/scripts/whitelist.conf", {
        environment      = var.environment,
        set_real_ip_from = var.set_real_ip_from,
        resolver         = var.resolver
    })
}

