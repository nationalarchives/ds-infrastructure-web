variable "deployment_configs" {}
variable "rollback_configs" {}

# codedeploy
#

module "codedeploy_web_wp" {
    source = "./codedeploy"

    app_name               = "web-wp"
    deployment_config_name = "web-wp"
    minimum_healthy_hosts  = var.deployment_configs.wordpress.minimum_healthy_hosts
    traffic_routing_config = var.deployment_configs.wordpress.traffic_routing_config

    deployment_group_name = "web-wp-group"
    service_role_arn      = module.roles.codedeploy_web_service_role_arn

    alarm_configuration          = var.rollback_configs.wordpress.alarm_conf
    auto_rollback_configuration  = var.rollback_configs.wordpress.rollback_conf
    blue_green_deployment_config = var.rollback_configs.wordpress.blue_green_conf
    deployment_style             = var.rollback_configs.wordpress.deployment_style
    ec2_tag_filters              = var.rollback_configs.wordpress.ec2_tag_filters
}

# codedeploy reverse proxy
#

module "codedeploy_web_reverse_proxy" {
    source = "./codedeploy_web_reverse_proxy"

    app_name               = "web-nginx-rp"
    deployment_config_name = "web-nginx-rp"
    minimum_healthy_hosts  = var.deployment_configs.web_reverse_proxy.minimum_healthy_hosts
    traffic_routing_config = var.deployment_configs.web_reverse_proxy.traffic_routing_config

    deployment_group_name = "web-nginx-rp-group"
    service_role_arn      = module.roles.codedeploy_web_reverse_proxy_service_role_arn

    alarm_configuration          = var.rollback_configs.web_reverse_proxy.alarm_conf
    auto_rollback_configuration  = var.rollback_configs.web_reverse_proxy.rollback_conf
    blue_green_deployment_config = var.rollback_configs.web_reverse_proxy.blue_green_conf
    deployment_style             = var.rollback_configs.web_reverse_proxy.deployment_style
    ec2_tag_filters              = var.rollback_configs.web_reverse_proxy.ec2_tag_filters
}
