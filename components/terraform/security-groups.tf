module "sgs" {
    source = "./security-groups"

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    lb_security_group_id = module.load-balancer.lb_security_group_id

    instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2b_cidr.value,
        data.aws_ssm_parameter.client_vpn_cidr.value,
    ]

    enrichment_sg_id = module.sgs.enrichment_sg_id

    redis_sg_id = module.sgs.redis_sg_id

    tags = local.tags
}
