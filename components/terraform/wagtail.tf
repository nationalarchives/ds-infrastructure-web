variable "wagtail_instance_type" {}
variable "wagtail_key_name" {}
variable "wagtail_root_block_device_size" {}
variable "wagtail_efs_mount_dir" {}

variable "wagtail_asg_max_size" {}
variable "wagtail_asg_min_size" {}
variable "wagtail_asg_desired_capacity" {}
variable "wagtail_asg_health_check_grace_period" {}
variable "wagtail_asg_health_check_type" {}

variable "wagtail_auto_switch_off" {}
variable "wagtail_auto_switch_on" {}
variable "wagtail_deployment_group" {}
variable "wagtail_patch_group" {}
variable "wagtail_deployment_s3_bucket" {}
variable "wagtail_folder_s3_key" {}

module "wagtail" {
    source = "./wagtail"

    ami_id = data.aws_ami.wagtail_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "wagtail"
    host_header = "wagtail.${var.environment}.local"

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    wagtail_sg_id = module.sgs.wagtail_sg_id

    efs_dns_name = module.media_efs.media_efs_dns_name

    wagtail_efs_mount_dir = var.wagtail_efs_mount_dir

    asg_max_size = var.wagtail_asg_max_size
    asg_min_size = var.wagtail_asg_min_size
    asg_desired_capacity = var.wagtail_asg_desired_capacity
    asg_health_check_grace_period = var.wagtail_asg_health_check_grace_period
    asg_health_check_type = var.wagtail_asg_health_check_type

    instance_type = var.wagtail_instance_type
    key_name = "wagtail-${var.environment}-eu-west-2"
    root_block_device_size = "100"

    auto_switch_off = var.wagtail_auto_switch_off
    auto_switch_on = var.wagtail_auto_switch_on
    deployment_group = var.wagtail_deployment_group
    patch_group = var.wagtail_patch_group

    deployment_s3_bucket = var.wagtail_deployment_s3_bucket
    folder_s3_key = var.wagtail_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
}
