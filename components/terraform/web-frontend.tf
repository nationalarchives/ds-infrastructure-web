variable "web_frontend_instance_type" {}

variable "web_frontend_asg_max_size" {}
variable "web_frontend_asg_min_size" {}
variable "web_frontend_asg_desired_capacity" {}
variable "web_frontend_asg_health_check_grace_period" {}
variable "web_frontend_asg_health_check_type" {}
variable "web_frontend_autoscaling_policy_name_prefix" {}
variable "web_frontend_default_cooldown" {}
variable "web_frontend_scale_in_threshold" {}
variable "web_frontend_scale_out_threshold" {}
variable "enable_autoscaling" {}

variable "web_frontend_auto_switch_off" {}
variable "web_frontend_auto_switch_on" {}
variable "web_frontend_deployment_group" {}
variable "web_frontend_patch_group" {}
variable "web_frontend_deployment_s3_bucket" {}
variable "web_frontend_folder_s3_key" {}
variable "web_frontend_root_block_device_size" {}
variable "enable_monitoring" {}

# module "notifications" {
#   source = "./chatbot/web-sns-notifications"

#   environment        = var.environment
#   slack_workspace_id = var.slack_workspace_id
#   slack_channel_id   = var.slack_channel_id
# }

module "web_frontend" {
    source = "./web-frontend"

    ami_id = data.aws_ami.web_frontend_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "web-frontend"
    host_header = "web-frontend.${var.environment}.local"

    lb_security_group_id = module.load-balancer.lb_security_group_id

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value
    
    enable_autoscaling = var.environment == "live" ? true : false
    autoscaling_policy_name_prefix = var.environment == "live" ? "web-frontend" : ""

    web_frontend_autoscaling_policy_name_prefix = var.environment == "live" ? "web-frontend" : ""
    asg_max_size = var.web_frontend_asg_max_size
    asg_min_size = var.web_frontend_asg_min_size
    asg_desired_capacity = var.web_frontend_asg_desired_capacity
    asg_health_check_grace_period = var.web_frontend_asg_health_check_grace_period
    asg_health_check_type = var.web_frontend_asg_health_check_type
    default_cooldown = var.web_frontend_default_cooldown
    scale_in_threshold = var.web_frontend_scale_in_threshold
    scale_out_threshold = var.web_frontend_scale_out_threshold

    instance_type = var.web_frontend_instance_type
    key_name = "web-frontend-${var.environment}-eu-west-2"
    root_block_device_size = var.web_frontend_root_block_device_size

    instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    auto_switch_off = var.web_frontend_auto_switch_off
    auto_switch_on = var.web_frontend_auto_switch_on
    deployment_group = var.web_frontend_deployment_group
    patch_group = var.web_frontend_patch_group
    enable_monitoring = var.enable_monitoring

    deployment_s3_bucket = var.web_frontend_deployment_s3_bucket
    folder_s3_key = var.web_frontend_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
    asg_notifications_sns_arn = module.notifications.sns_topic_arn
}
