resource "aws_s3_object" "admin_conf" {
    bucket = var.deployment_s3_bucket
    key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/wp_admin.conf"
    content = templatefile("${path.module}/scripts/${var.nginx_version}/wp_admin.conf", {
        environment      = var.environment,
        set_real_ip_from = var.set_real_ip_from,
        resolver         = var.resolver
    })
}

resource "aws_s3_object" "admin_ips_conf" {
    bucket = var.deployment_s3_bucket
    key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/admin_ips.conf"
    content = templatefile("${path.module}/scripts/${var.nginx_version}/admin_ips.conf", {
        admin_list = var.admin_list
    })
}

resource "aws_s3_object" "admin_subdomain_conf" {
    bucket = var.deployment_s3_bucket
    key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/wp_admin_subdomain.conf"
    content = templatefile("${path.module}/scripts/${var.nginx_version}/wp_admin_subdomain.conf", {
        environment      = var.environment,
        set_real_ip_from = var.set_real_ip_from,
        resolver         = var.resolver
    })
}

resource "aws_s3_object" "blog_conf" {
    bucket = var.deployment_s3_bucket
    key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/blog.conf"
    content = templatefile("${path.module}/scripts/${var.nginx_version}/blog.conf", {
        environment = var.environment
    })
}

resource "aws_s3_object" "cloudfront_ips_conf" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/cloudfront_ips.conf"
  source = "${path.module}/scripts/${var.nginx_version}/cloudfront_ips.conf"
  source_hash = filemd5("${path.module}/scripts/${var.nginx_version}/cloudfront_ips.conf")
}

resource "aws_s3_object" "media_conf" {
    bucket = var.deployment_s3_bucket
    key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/media.conf"
    content = templatefile("${path.module}/scripts/${var.nginx_version}/media.conf", {
        environment = var.environment
    })
}

resource "aws_s3_object" "mime_types" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/mime.types"
  source = "${path.module}/scripts/${var.nginx_version}/mime.types"
  source_hash = filemd5("${path.module}/scripts/${var.nginx_version}/mime.types")
}

resource "aws_s3_object" "nginx_conf" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/nginx.conf"
  content = templatefile("${path.module}/scripts/${var.nginx_version}/nginx.conf", {
        environment      = var.environment,
        set_real_ip_from = var.set_real_ip_from,
        resolver         = var.resolver,
        ups_appslb             = var.ups_appslb,
        ups_legacy_apps        = var.ups_legacy_apps,
        ups_pronom             = var.ups_pronom,
        ups_ecommerce_be       = var.ups_ecommerce_be,
        ups_services           = var.ups_services,
        ups_win2016apps        = var.ups_win2016apps,
        ups_win2016apps_host   = var.ups_win2016apps_host,
        ups_win2016web         = var.ups_win2016web,
        ups_win2016web_host    = var.ups_win2016web_host,
        streamline_access_list = var.streamline_access_list,
  })
}

resource "aws_s3_object" "redirects_conf" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/redirects.conf"
  source = "${path.module}/scripts/${var.nginx_version}/redirects.conf"
  source_hash = filemd5("${path.module}/scripts/${var.nginx_version}/redirects.conf")
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
        environment          = var.environment,
        set_real_ip_from     = var.set_real_ip_from,
        resolver             = var.resolver,
        ups_appslb           = var.ups_appslb,
        ups_legacy_apps      = var.ups_legacy_apps,
        ups_ecommerce_be     = var.ups_ecommerce_be,
        ups_services         = var.ups_services,
        ups_win2016apps      = var.ups_win2016apps,
        ups_win2016apps_host = var.ups_win2016apps_host,
        ups_win2016web       = var.ups_win2016web,
        ups_win2016web_host  = var.ups_win2016web_host,
        ups_pronom           = var.ups_pronom
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

resource "aws_s3_object" "web_enrichment_conf" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/web-enrichment.conf"
  content = templatefile("${path.module}/scripts/${var.nginx_version}/web-enrichment.conf", {
    environment      = var.environment,
    set_real_ip_from = var.set_real_ip_from
  })
}

resource "aws_s3_object" "web_forms_conf" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/web-forms.conf"
  content = templatefile("${path.module}/scripts/${var.nginx_version}/web-forms.conf", {
    environment      = var.environment,
    set_real_ip_from = var.set_real_ip_from
  })
}

resource "aws_s3_object" "web_frontend_conf" {
  bucket = var.deployment_s3_bucket
  key    = "${var.service}/${var.nginx_folder_s3_key}/${var.nginx_version}/web-frontend.conf"
  content = templatefile("${path.module}/scripts/${var.nginx_version}/web-frontend.conf", {
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
