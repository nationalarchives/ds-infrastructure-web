module "load-balancer" {
  source = "./load-balancer"

  vpc_id = data.aws_ssm_parameter.vpc_id.value

  subnet_ids = [
    data.aws_ssm_parameter.private_subnet_2a_id.value,
    data.aws_ssm_parameter.private_subnet_2b_id.value
  ]

  lb_cidr = [
    data.aws_ssm_parameter.private_subnet_2a_cidr.value,
    data.aws_ssm_parameter.private_subnet_2b_cidr.value,
  ]

  tags = local.tags
}
