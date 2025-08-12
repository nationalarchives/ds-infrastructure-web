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

    enrichment_lb_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    enrichment_instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2b_cidr.value,
        data.aws_ssm_parameter.client_vpn_cidr.value,
    ]
    enrichment_sg_id = module.sgs.enrichment_sg_id
    enrichment_lb_id = module.sgs.enrichment_lb_id

    redis_lb_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    redis_instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2b_cidr.value,
        data.aws_ssm_parameter.client_vpn_cidr.value,
    ]

    redis_sg_id = module.sgs.redis_sg_id
    redis_lb_id = module.sgs.redis_lb_id

    catalogue_lb_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    catalogue_instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2b_cidr.value,
        data.aws_ssm_parameter.client_vpn_cidr.value,
    ]

    search_lb_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    search_instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2b_cidr.value,
        data.aws_ssm_parameter.client_vpn_cidr.value,
    ]

    tags = local.tags
}
