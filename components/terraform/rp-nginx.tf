module "conf-efs" {
    source = "./rp-nginx/conf-efs"

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subs = [
        data.aws_ssm_parameter.private_subnet_2a_id.value,
        data.aws_ssm_parameter.private_subnet_2b_id.value,
    ]

    tags = local.tags
}
