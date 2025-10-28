variable "catalogue_instance_type" {}
variable "catalogue_key_name" {}
variable "catalogue_root_block_device_size" {}
variable "catalogue_efs_mount_dir" {}

variable "catalogue_asg_max_size" {}
variable "catalogue_asg_min_size" {}
variable "catalogue_asg_desired_capacity" {}
variable "catalogue_asg_health_check_grace_period" {}
variable "catalogue_asg_health_check_type" {}

variable "catalogue_auto_switch_off" {}
variable "catalogue_auto_switch_on" {}
variable "catalogue_deployment_group" {}
variable "catalogue_patch_group" {}
variable "catalogue_deployment_s3_bucket" {}
variable "catalogue_folder_s3_key" {}

module "catalogue" {
    source = "./catalogue"

    ami_id = data.aws_ami.catalogue_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "catalogue"
    host_header = "catalogue.${var.environment}.local"

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    catalogue_sg_id = module.sgs.catalogue_sg_id
    catalogue_lb_id = module.sgs.catalogue_lb

    efs_dns_name = module.media_efs.media_efs_dns_name

    catalogue_efs_mount_dir = var.catalogue_efs_mount_dir

    asg_max_size = var.catalogue_asg_max_size
    asg_min_size = var.catalogue_asg_min_size
    asg_desired_capacity = var.catalogue_asg_desired_capacity
    asg_health_check_grace_period = var.catalogue_asg_health_check_grace_period
    asg_health_check_type = var.catalogue_asg_health_check_type

    instance_type = var.catalogue_instance_type
    key_name = "catalogue-${var.environment}-eu-west-2"
    root_block_device_size = "100"


    instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    auto_switch_off = var.catalogue_auto_switch_off
    auto_switch_on = var.catalogue_auto_switch_on
    deployment_group = var.catalogue_deployment_group
    patch_group = var.catalogue_patch_group

    deployment_s3_bucket = var.catalogue_deployment_s3_bucket
    folder_s3_key = var.catalogue_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
}
