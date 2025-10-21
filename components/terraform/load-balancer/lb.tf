resource "aws_lb" "web_services" {
  name               = "web-services"
  internal           = true
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.web_services_lb.id,
  ]

  subnets = var.subnet_ids

  tags = var.tags
}

resource "aws_security_group" "web_services_lb" {
  name        = "web-services-lb"
  description = "Reverse Proxy Security Group HTTP access"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "web-services-lb"
  })
}

resource "aws_security_group_rule" "web_services_lb_http_ingress" {
  cidr_blocks       = var.lb_cidr
  description       = "port 80 traffic from RPs"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.web_services_lb.id
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "web_services_lb_http_egress" {
  security_group_id = aws_security_group.web_services_lb.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
