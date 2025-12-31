variable "web_wagtaildocs_instance_type" {}
variable "web_wagtaildocs_key_name" {}
variable "web_wagtaildocs_root_block_device_size" {}
variable "web_wagtaildocs_efs_mount_dir" {}

variable "web_wagtaildocs_asg_max_size" {}
variable "web_wagtaildocs_asg_min_size" {}
variable "web_wagtaildocs_asg_desired_capacity" {}
variable "web_wagtaildocs_asg_health_check_grace_period" {}
variable "web_wagtaildocs_asg_health_check_type" {}
variable "web_wagtaildocs_auto_switch_off" {}
variable "web_wagtaildocs_auto_switch_on" {}
variable "web_wagtaildocs_deployment_group" {}
variable "web_wagtaildocs_patch_group" {}
variable "web_wagtaildocs_deployment_s3_bucket" {}
variable "web_wagtaildocs_folder_s3_key" {}

module "web_wagtaildocs" {
    source = "./web-wagtaildocs"

    ami_id = data.aws_ami.web_wagtaildocs_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "web-wagtaildocs"
    host_header = "web-wagtaildocs.${var.environment}.local"

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    web_wagtaildocs_sg_id = module.sgs.web_wagtaildocs_sg_id

    efs_dns_name = module.media_efs.media_efs_dns_name
    enable_monitoring = var.enable_monitoring

    web_wagtaildocs_efs_mount_dir = var.web_wagtaildocs_efs_mount_dir
    asg_max_size = var.web_wagtaildocs_asg_max_size
    asg_min_size = var.web_wagtaildocs_asg_min_size
    asg_desired_capacity = var.web_wagtaildocs_asg_desired_capacity
    asg_health_check_grace_period = var.web_wagtaildocs_asg_health_check_grace_period
    asg_health_check_type = var.web_wagtaildocs_asg_health_check_type

    instance_type = var.web_wagtaildocs_instance_type
    key_name = "wagtaildocs-${var.environment}-eu-west-2"
    root_block_device_size = "100"


    instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    auto_switch_off = var.web_wagtaildocs_auto_switch_off
    auto_switch_on = var.web_wagtaildocs_auto_switch_on
    deployment_group = var.web_wagtaildocs_deployment_group
    patch_group = var.web_wagtaildocs_patch_group

    deployment_s3_bucket = var.web_wagtaildocs_deployment_s3_bucket
    folder_s3_key = var.web_wagtaildocs_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
}
