# -----------------------------------------------------------------------------
# Media EFS Security Group
# -----------------------------------------------------------------------------
resource "aws_security_group" "media_efs" {
  name        = "web-media-efs"
  description = "ec2 access to media efs"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "web-media-efs"
  })
}

# Allow EC2 (web-wagtail) to mount EFS
resource "aws_security_group_rule" "media_mount_efs_ingress" {
  description              = "Allow NFS from web-wagtail EC2"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2049
  to_port                  = 2049
  security_group_id        = aws_security_group.media_efs.id
  source_security_group_id = var.web_wagtail_sg_id
}