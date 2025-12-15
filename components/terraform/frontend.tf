variable "frontend_instance_type" {}

variable "frontend_asg_max_size" {}
variable "frontend_asg_min_size" {}
variable "frontend_asg_desired_capacity" {}
variable "frontend_asg_health_check_grace_period" {}
variable "frontend_asg_health_check_type" {}
variable "frontend_autoscaling_policy_name_prefix" {}
variable "frontend_default_cooldown" {}
variable "frontend_scale_in_threshold" {}
variable "frontend_scale_out_threshold" {}
variable "enable_autoscaling" {}

variable "frontend_auto_switch_off" {}
variable "frontend_auto_switch_on" {}
variable "frontend_deployment_group" {}
variable "frontend_patch_group" {}
variable "frontend_deployment_s3_bucket" {}
variable "frontend_folder_s3_key" {}
variable "frontend_root_block_device_size" {}

module "frontend" {
    source = "./frontend"

    ami_id = data.aws_ami.frontend_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "web-frontend"
    host_header = "web-frontend.${var.environment}.local"

    lb_security_group_id = module.load-balancer.lb_security_group_id

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value
    enable_autoscaling = var.environment == "live" ? true : false
    autoscaling_policy_name_prefix = var.environment == "live" ? "web-frontend" : ""

    #enable_autoscaling = var.environment == "live" ? true : false
    frontend_autoscaling_policy_name_prefix = var.environment == "live" ? "web-frontend" : ""
    asg_max_size = var.frontend_asg_max_size
    asg_min_size = var.frontend_asg_min_size
    asg_desired_capacity = var.frontend_asg_desired_capacity
    asg_health_check_grace_period = var.frontend_asg_health_check_grace_period
    asg_health_check_type = var.frontend_asg_health_check_type
    #autoscaling_policy_name_prefix = var.frontend_autoscaling_policy_name_prefix
    default_cooldown = var.frontend_default_cooldown
    scale_in_threshold = var.frontend_scale_in_threshold
    scale_out_threshold = var.frontend_scale_out_threshold

    instance_type = var.frontend_instance_type
    key_name = "web-frontend-${var.environment}-eu-west-2"
    root_block_device_size = var.frontend_root_block_device_size

    instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    auto_switch_off = var.frontend_auto_switch_off
    auto_switch_on = var.frontend_auto_switch_on
    deployment_group = var.frontend_deployment_group
    patch_group = var.frontend_patch_group

    deployment_s3_bucket = var.frontend_deployment_s3_bucket
    folder_s3_key = var.frontend_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
}
