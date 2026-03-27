# -----------------------------------------------------------------------------
# Nginx EFS Security Group
# -----------------------------------------------------------------------------
resource "aws_security_group" "nginx_efs" {
  name        = "web-nginx-efs"
  description = "ec2 access to nginx efs"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "web-nginx-efs"
  })
}

# Allow EC2 (web-reverse-proxy) to mount EFS
resource "aws_security_group_rule" "nginx_efs_ingress" {
  description              = "Allow NFS from web-reverse-proxy EC2"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2049
  to_port                  = 2049
  security_group_id        = aws_security_group.nginx_efs.id
  source_security_group_id = var.web_reverse_proxy_sg_id
}