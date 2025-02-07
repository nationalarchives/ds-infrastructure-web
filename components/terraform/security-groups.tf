module "sgs" {
    source = "./security-groups"

    vpc_id = data.aws_ssm_parameter.vpc_id.value

    rp_instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    frontend_lb_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    frontend_instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2b_cidr.value,
        data.aws_ssm_parameter.client_vpn_cidr.value,
    ]

    db_instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    wagtail_lb_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    wagtail_instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2b_cidr.value,
        data.aws_ssm_parameter.client_vpn_cidr.value,
    ]

    tags = local.tags
}
