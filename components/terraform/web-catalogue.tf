variable "web_catalogue_instance_type" {}
variable "web_catalogue_key_name" {}
variable "web_catalogue_root_block_device_size" {}
variable "web_catalogue_efs_mount_dir" {}

variable "web_catalogue_asg_max_size" {}
variable "web_catalogue_asg_min_size" {}
variable "web_catalogue_asg_desired_capacity" {}
variable "web_catalogue_asg_health_check_grace_period" {}
variable "web_catalogue_asg_health_check_type" {}
variable "web_catalogue_autoscaling_policy_name_prefix" {}
variable "web_catalogue_default_cooldown" {}
variable "web_catalogue_scale_in_threshold" {}
variable "web_catalogue_scale_out_threshold" {}

variable "web_catalogue_auto_switch_off" {}
variable "web_catalogue_auto_switch_on" {}
variable "web_catalogue_deployment_group" {}
variable "web_catalogue_patch_group" {}
variable "web_catalogue_deployment_s3_bucket" {}
variable "web_catalogue_folder_s3_key" {}

module "web-catalogue" {
    source = "./web-catalogue"

    ami_id = data.aws_ami.web_catalogue_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "web-catalogue"
    host_header = "web-catalogue.${var.environment}.local"

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    web_catalogue_sg_id = module.sgs.web_catalogue_sg_id

    efs_dns_name = module.media_efs.media_efs_dns_name

    web_catalogue_efs_mount_dir = var.web_catalogue_efs_mount_dir

    enable_autoscaling = var.environment == "live" ? true : false
    autoscaling_policy_name_prefix = var.environment == "live" ? "web-catalogue" : ""
    web_catalogue_autoscaling_policy_name_prefix = var.environment == "live" ? "web-catalogue" : ""
    asg_max_size = var.web_catalogue_asg_max_size
    asg_min_size = var.web_catalogue_asg_min_size
    asg_desired_capacity = var.web_catalogue_asg_desired_capacity
    asg_health_check_grace_period = var.web_catalogue_asg_health_check_grace_period
    asg_health_check_type = var.web_catalogue_asg_health_check_type
    default_cooldown = var.web_catalogue_default_cooldown
    scale_in_threshold = var.web_catalogue_scale_in_threshold
    scale_out_threshold = var.web_catalogue_scale_out_threshold

    instance_type = var.web_catalogue_instance_type
    key_name = "catalogue-${var.environment}-eu-west-2"
    root_block_device_size = "100"


    instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    auto_switch_off = var.web_catalogue_auto_switch_off
    auto_switch_on = var.web_catalogue_auto_switch_on
    deployment_group = var.web_catalogue_deployment_group
    patch_group = var.web_catalogue_patch_group

    deployment_s3_bucket = var.web_catalogue_deployment_s3_bucket
    folder_s3_key = var.web_catalogue_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
}
