variable "web_reverse_proxy_instance_type" {}
variable "web_reverse_proxy_key_name" {}
variable "web_reverse_proxy_root_block_device_size" {}
variable "web_reverse_proxy_asg_max_size" {}
variable "web_reverse_proxy_asg_min_size" {}
variable "web_reverse_proxy_asg_desired_capacity" {}
variable "web_reverse_proxy_asg_health_check_grace_period" {}
variable "web_reverse_proxy_asg_health_check_type" {}
variable "web_reverse_proxy_autoscaling_policy_name_prefix" {}
variable "web_reverse_proxy_default_cooldown" {}
variable "web_reverse_proxy_scale_in_threshold" {}
variable "web_reverse_proxy_scale_out_threshold" {}
variable "web_reverse_proxy_auto_switch_off" {}
variable "web_reverse_proxy_auto_switch_on" {}
variable "web_reverse_proxy_deployment_group" {}
variable "web_reverse_proxy_patch_group" {}
variable "web_reverse_proxy_deployment_s3_bucket" {}
variable "web_reverse_proxy_folder_s3_key" {}
variable "web_reverse_proxy_wagtail_efs_mount_dir" {}
variable "nginx_folder_s3_key" {}
variable "vpc_cidr" {}
variable "intersite_vpc_and_clientvpn_cidr" {}
variable "resolver" {}
variable "ups_ecommerce_be" {}
variable "ups_services" {}
variable "ups_win2016apps" {}
variable "ups_win2016web" {}
variable "ups_win2016web_host" {}
variable "ups_appslb" {}
variable "ups_legacy_apps" {}
variable "ups_win2016apps_host" {}
variable "site_access_list" {}
variable "admin_list" {}
variable "ups_pronom" {}
variable "streamline_access_list" {}
variable "efs_mount_dir" {}
variable "public_domain_name" {}

module "web_reverse_proxy" {
    source = "./web-reverse-proxy"

    ami_id = data.aws_ami.web_reverse_proxy_ami.id
    web_reverse_proxy_role_name            = module.roles.web_reverse_proxy_role_name
    web_reverse_proxy_instance_profile_arn = module.roles.web_reverse_proxy_instance_profile_arn
    service = var.service
    #efs_dns_name = module.media_efs.media_efs_dns_name
    efs_mount_dir = var.efs_mount_dir
    web_reverse_proxy_wagtail_efs_mount_dir = var.web_reverse_proxy_wagtail_efs_mount_dir  
    mount_target = data.aws_ssm_parameter.website_efs_reverse_proxy_dns_name.value
    mount_wagtail_media = data.aws_ssm_parameter.wagtail_efs_media_dns_name.value
    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "web-reverse-proxy"
    host_header = "web-reverse-proxy.${var.environment}.local"
    lb_sg_id = module.sgs.web_reverse_proxy_sg_id
    web_reverse_proxy_lb_security_group_id = module.sgs.web_reverse_proxy_lb_security_group_id

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    vpn_cidr      = var.intersite_vpc_and_clientvpn_cidr
    public_domain_name             = var.public_domain_name
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value
    public_subnet_a_id  = data.aws_ssm_parameter.public_subnet_2a_id.value
    public_subnet_b_id  = data.aws_ssm_parameter.public_subnet_2b_id.value
    public_ssl_cert_arn = data.aws_ssm_parameter.wildcard_certificate_arn.value
    sub_sub_domain_ssl_cert_arn   = data.aws_ssm_parameter.admin_subdomain_certificate_arn.value

    enable_autoscaling = var.environment == "live" ? true : false
    autoscaling_policy_name_prefix = var.environment == "live" ? "web-reverse-proxy" : ""
    web_reverse_proxy_autoscaling_policy_name_prefix = var.environment == "live" ? "web-reverse-proxy" : ""
    web_reverse_proxy_sg_id = module.sgs.web_reverse_proxy_sg_id    
    
    enable_monitoring = var.enable_monitoring
    asg_max_size = var.web_reverse_proxy_asg_max_size
    asg_min_size = var.web_reverse_proxy_asg_min_size
    asg_desired_capacity = var.web_reverse_proxy_asg_desired_capacity
    asg_health_check_grace_period = var.web_reverse_proxy_asg_health_check_grace_period
    asg_health_check_type = var.web_reverse_proxy_asg_health_check_type
    default_cooldown = var.web_reverse_proxy_default_cooldown
    scale_in_threshold = var.web_reverse_proxy_scale_in_threshold
    scale_out_threshold = var.web_reverse_proxy_scale_out_threshold
    asg_tags = local.asg_default_tags
    asg_notifications_sns_arn = module.notifications.sns_topic_arn

    instance_type = var.web_reverse_proxy_instance_type
    key_name = "web-frontend-${var.environment}-eu-west-2"
    root_block_device_size = "100"
    auto_switch_off = var.web_reverse_proxy_auto_switch_off
    auto_switch_on = var.web_reverse_proxy_auto_switch_on
    deployment_group = var.web_reverse_proxy_deployment_group
    patch_group = var.web_reverse_proxy_patch_group
    deployment_s3_bucket = var.web_reverse_proxy_deployment_s3_bucket
    folder_s3_key = var.web_reverse_proxy_folder_s3_key
    tags = local.tags
}

module "nginx_conf" {
    source = "./nginx-conf"

    service              = var.service
    deployment_s3_bucket = var.deployment_s3_bucket
    nginx_folder_s3_key  = "nginx"
    efs_mount_dir        = "/mnt/efs"
    environment            = var.environment
    resolver               = var.resolver
    set_real_ip_from       = var.vpc_cidr
    ups_appslb             = var.ups_appslb
    ups_legacy_apps        = var.ups_legacy_apps
    ups_pronom             = var.ups_pronom
    ups_ecommerce_be       = var.ups_ecommerce_be
    ups_services           = var.ups_services
    ups_win2016apps        = var.ups_win2016apps
    ups_win2016apps_host   = var.ups_win2016apps_host
    ups_win2016web         = var.ups_win2016web
    ups_win2016web_host    = var.ups_win2016web_host
    streamline_access_list = var.streamline_access_list

    admin_list = concat([var.vpc_cidr], var.admin_list)
    site_access_list = concat([var.vpc_cidr], var.site_access_list)
}
