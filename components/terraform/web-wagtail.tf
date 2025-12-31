variable "web_wagtail_instance_type" {}
variable "web_wagtail_key_name" {}
variable "web_wagtail_root_block_device_size" {}
variable "web_wagtail_efs_mount_dir" {}

variable "web_wagtail_asg_max_size" {}
variable "web_wagtail_asg_min_size" {}
variable "web_wagtail_asg_desired_capacity" {}
variable "web_wagtail_asg_health_check_grace_period" {}
variable "web_wagtail_asg_health_check_type" {}
variable "web_wagtail_autoscaling_policy_name_prefix" {}
variable "web_wagtail_default_cooldown" {}
variable "web_wagtail_scale_in_threshold" {}
variable "web_wagtail_scale_out_threshold" {}
variable "web_wagtail_auto_switch_off" {}
variable "web_wagtail_auto_switch_on" {}
variable "web_wagtail_deployment_group" {}
variable "web_wagtail_patch_group" {}
variable "web_wagtail_deployment_s3_bucket" {}
variable "web_wagtail_folder_s3_key" {}

module "web_wagtail" {
    source = "./web-wagtail"

    ami_id = data.aws_ami.web_wagtail_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "web-wagtail"
    host_header = "web-wagtail.${var.environment}.local"

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    enable_autoscaling = var.environment == "live" ? true : false
    autoscaling_policy_name_prefix = var.environment == "live" ? "web-wagtail" : ""
    web_wagtail_autoscaling_policy_name_prefix = var.environment == "live" ? "web-wagtail" : ""
    asg_max_size = var.web_wagtail_asg_max_size
    asg_min_size = var.web_wagtail_asg_min_size
    asg_desired_capacity = var.web_wagtail_asg_desired_capacity
    asg_health_check_grace_period = var.web_wagtail_asg_health_check_grace_period
    asg_health_check_type = var.web_wagtail_asg_health_check_type
    default_cooldown = var.web_wagtail_default_cooldown
    scale_in_threshold = var.web_wagtail_scale_in_threshold
    scale_out_threshold = var.web_wagtail_scale_out_threshold
    enable_monitoring = var.enable_monitoring


    web_wagtail_sg_id = module.sgs.web_wagtail_sg_id

    efs_dns_name = module.media_efs.media_efs_dns_name

    web_wagtail_efs_mount_dir = var.web_wagtail_efs_mount_dir    
    instance_type = var.web_wagtail_instance_type
    key_name = "wagtail-${var.environment}-eu-west-2"
    root_block_device_size = "100"

    auto_switch_off = var.web_wagtail_auto_switch_off
    auto_switch_on = var.web_wagtail_auto_switch_on
    deployment_group = var.web_wagtail_deployment_group
    patch_group = var.web_wagtail_patch_group

    deployment_s3_bucket = var.web_wagtail_deployment_s3_bucket
    folder_s3_key = var.web_wagtail_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
}
