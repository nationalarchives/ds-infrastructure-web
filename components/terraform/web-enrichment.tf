variable "web_enrichment_instance_type" {}
variable "web_enrichment_key_name" {}
variable "web_enrichment_root_block_device_size" {}

variable "web_enrichment_asg_max_size" {}
variable "web_enrichment_asg_min_size" {}
variable "web_enrichment_asg_desired_capacity" {}
variable "web_enrichment_asg_health_check_grace_period" {}
variable "web_enrichment_asg_health_check_type" {}

variable "web_enrichment_auto_switch_off" {}
variable "web_enrichment_auto_switch_on" {}
variable "web_enrichment_deployment_group" {}
variable "web_enrichment_patch_group" {}
variable "web_enrichment_deployment_s3_bucket" {}
variable "web_enrichment_folder_s3_key" {}

module "web_enrichment" {
    source = "./web-enrichment"

    ami_id = data.aws_ami.web_enrichment_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "web-enrichment"
    host_header = "web-enrichment.${var.environment}.local"

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    web_enrichment_sg_id = module.sgs.web_enrichment_sg_id

    asg_max_size = var.web_enrichment_asg_max_size
    asg_min_size = var.web_enrichment_asg_min_size
    asg_desired_capacity = var.web_enrichment_asg_desired_capacity
    asg_health_check_grace_period = var.web_enrichment_asg_health_check_grace_period
    asg_health_check_type = var.web_enrichment_asg_health_check_type

    instance_type = var.web_enrichment_instance_type
    key_name = "web-enrichment-${var.environment}-eu-west-2"
    root_block_device_size = "100"

    auto_switch_off = var.web_enrichment_auto_switch_off
    auto_switch_on = var.web_enrichment_auto_switch_on
    deployment_group = var.web_enrichment_deployment_group
    patch_group = var.web_enrichment_patch_group

    deployment_s3_bucket = var.web_enrichment_deployment_s3_bucket
    folder_s3_key = var.web_enrichment_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
}
