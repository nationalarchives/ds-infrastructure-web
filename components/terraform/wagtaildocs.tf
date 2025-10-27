variable "wagtaildocs_instance_type" {}
variable "wagtaildocs_key_name" {}
variable "wagtaildocs_root_block_device_size" {}
variable "wagtaildocs_efs_mount_dir" {}

variable "wagtaildocs_asg_max_size" {}
variable "wagtaildocs_asg_min_size" {}
variable "wagtaildocs_asg_desired_capacity" {}
variable "wagtaildocs_asg_health_check_grace_period" {}
variable "wagtaildocs_asg_health_check_type" {}

variable "wagtaildocs_auto_switch_off" {}
variable "wagtaildocs_auto_switch_on" {}
variable "wagtaildocs_deployment_group" {}
variable "wagtaildocs_patch_group" {}
variable "wagtaildocs_deployment_s3_bucket" {}
variable "wagtaildocs_folder_s3_key" {}

module "wagtaildocs" {
    source = "./wagtaildocs"

    ami_id = data.aws_ami.wagtaildocs_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    origin_header = "http://web-frontend.${var.environment}.local"

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    wagtaildocs_sg_id = module.sgs.wagtaildocs_sg_id
    wagtaildocs_lb_id = module.sgs.wagtaildocs_lb

    efs_dns_name = module.media_efs.media_efs_dns_name

    wagtaildocs_efs_mount_dir = var.wagtaildocs_efs_mount_dir

    asg_max_size = var.wagtaildocs_asg_max_size
    asg_min_size = var.wagtaildocs_asg_min_size
    asg_desired_capacity = var.wagtaildocs_asg_desired_capacity
    asg_health_check_grace_period = var.wagtaildocs_asg_health_check_grace_period
    asg_health_check_type = var.wagtaildocs_asg_health_check_type

    instance_type = var.wagtaildocs_instance_type
    key_name = "wagtaildocs-${var.environment}-eu-west-2"
    root_block_device_size = "100"


    instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    auto_switch_off = var.wagtaildocs_auto_switch_off
    auto_switch_on = var.wagtaildocs_auto_switch_on
    deployment_group = var.wagtaildocs_deployment_group
    patch_group = var.wagtaildocs_patch_group

    deployment_s3_bucket = var.wagtaildocs_deployment_s3_bucket
    folder_s3_key = var.wagtaildocs_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
}
