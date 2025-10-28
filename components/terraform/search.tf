variable "search_instance_type" {}
variable "search_key_name" {}
variable "search_root_block_device_size" {}
variable "search_efs_mount_dir" {}

variable "search_asg_max_size" {}
variable "search_asg_min_size" {}
variable "search_asg_desired_capacity" {}
variable "search_asg_health_check_grace_period" {}
variable "search_asg_health_check_type" {}

variable "search_auto_switch_off" {}
variable "search_auto_switch_on" {}
variable "search_deployment_group" {}
variable "search_patch_group" {}
variable "search_deployment_s3_bucket" {}
variable "search_folder_s3_key" {}

module "search" {
    source = "./search"

    ami_id = data.aws_ami.search_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "search"
    host_header = "search.${var.environment}.local"

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    search_sg_id = module.sgs.search_sg_id
    search_lb_id = module.sgs.search_lb

    efs_dns_name = module.media_efs.media_efs_dns_name

    search_efs_mount_dir = var.search_efs_mount_dir

    asg_max_size = var.search_asg_max_size
    asg_min_size = var.search_asg_min_size
    asg_desired_capacity = var.search_asg_desired_capacity
    asg_health_check_grace_period = var.search_asg_health_check_grace_period
    asg_health_check_type = var.search_asg_health_check_type

    instance_type = var.search_instance_type
    key_name = "search-${var.environment}-eu-west-2"
    root_block_device_size = "100"

    auto_switch_off = var.search_auto_switch_off
    auto_switch_on = var.search_auto_switch_on
    deployment_group = var.search_deployment_group
    patch_group = var.search_patch_group

    deployment_s3_bucket = var.search_deployment_s3_bucket
    folder_s3_key = var.search_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
}
