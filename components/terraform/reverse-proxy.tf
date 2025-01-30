locals {
    rp_asg_tags = [
        {
            key                 = "Name"
            value               = "web-rp"
            propagate_at_launch = "true"
        },
        {
            key                 = "Service"
            value               = "web"
            propagate_at_launch = "true"
        },
        {
            key                 = "Owner"
            value               = local.tags.Owner
            propagate_at_launch = "true"
        },
        {
            key                 = "CostCentre"
            value               = local.tags.CostCentre
            propagate_at_launch = "true"
        },
        {
            key                 = "Terraform"
            value               = "true"
            propagate_at_launch = "true"
        },
        {
            key                 = "PatchGroup"
            value               = var.rp_nginx_patch_group
            propagate_at_launch = "true"
        },
        {
            key                 = "Deployment-Group"
            value               = var.rp_nginx_deployment_group
            propagate_at_launch = "true"
        },
        {
            key                 = "AutoSwitchOn"
            value               = "true"
            propagate_at_launch = "true"
        },
        {
            key                 = "AutoSwitchOff"
            value               = "true"
            propagate_at_launch = "true"
        },
    ]

}

# reverse proxy
#
variable "rp_nginx_patch_group" {}
variable "rp_nginx_deployment_group" {}

variable "rp_instance_type" {}
variable "rp_key_name" {}
variable "rp_folder_s3_key" {}

variable "rp_efs_mount_dir" {}

variable "rp_root_block_device_size" {}

# auto-scaling
#
variable "rp_asg_max_size" {}
variable "rp_asg_min_size" {}
variable "rp_asg_desired_capacity" {}
variable "rp_asg_health_check_grace_period" {}
variable "rp_asg_health_check_type" {}

module "reverse-proxy" {
    source = "./reverse-proxy"

    # networking
    #
    vpc_id              = data.aws_ssm_parameter.vpc_id.value
    vpc_cidr            = data.aws_ssm_parameter.vpc_cidr.value
    public_subnet_a_id  = data.aws_ssm_parameter.public_subnet_2a_id.value
    public_subnet_b_id  = data.aws_ssm_parameter.public_subnet_2b_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    lb_sg_id    = module.sgs.rp_lb_sg_id
    profile_arn = module.roles.rp_profile_arn
    sg_ids       = [
        module.sgs.rp_sg_id,
        module.sgs.ec2_mount_efs_sg_id,
    ]

    efs_dns_name  = module.media_efs.media_efs_dns_name
    efs_mount_dir = var.rp_efs_mount_dir

    custom_header_name  = jsondecode(data.aws_secretsmanager_secret_version.beta_custom_header.secret_string)["header_name"]
    custom_header_value = jsondecode(data.aws_secretsmanager_secret_version.beta_custom_header.secret_string)["header_value"]

    # launch configuration
    #
    image_id               = data.aws_ami.web_rp_ami.id
    instance_type          = var.rp_instance_type
    key_name               = var.rp_key_name
    root_block_device_size = var.rp_root_block_device_size
    nginx_folder_s3_key    = var.rp_folder_s3_key

    # auto-scaling
    #
    asg_max_size                  = var.rp_asg_max_size
    asg_min_size                  = var.rp_asg_min_size
    asg_desired_capacity          = var.rp_asg_desired_capacity
    asg_health_check_grace_period = var.rp_asg_health_check_grace_period
    asg_health_check_type         = var.rp_asg_health_check_type

    asg_tags = local.rp_asg_tags

    deployment_s3_bucket = var.deployment_s3_bucket
    logfile_s3_bucket    = var.logfile_s3_bucket

    # certificates
    #
    ssl_cert_arn = data.aws_ssm_parameter.wildcard_certificate_arn.value

    tags = merge(local.tags, {
        service = "web-reverse-proxy"
    })
}
