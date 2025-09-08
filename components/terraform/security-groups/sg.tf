# EFS access
#
resource "aws_security_group" "ec2_mount_media_efs" {
    name        = "web-ec2-mount-media-efs"
    description = "ec2 security group to mount media EFS"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-ec2-mount-media-efs"
    })
}


resource "aws_security_group" "upload_efs" {
    name        = "web-upload-efs-access"
    description = "access to EFS storage"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-upload-efs-access"
    })
}

resource "aws_security_group_rule" "frontend_efs_ingress" {
    description              = "EFS mount target"
    from_port                = 2049
    protocol                 = "tcp"
    security_group_id        = aws_security_group.upload_efs.id
    to_port                  = 2049
    type                     = "ingress"
    source_security_group_id = aws_security_group.upload_efs.id
}

resource "aws_security_group_rule" "efs_egress" {
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    security_group_id = aws_security_group.upload_efs.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
}

resource "aws_security_group" "rp_lc" {
    name        = "web-rp-lc-sg"
    description = "reverse proxy security group"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "web-rp-sg"
    })
}

resource "aws_vpc_security_group_ingress_rule" "rp_lc_http" {
    security_group_id = aws_security_group.rp_lc.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 80
    ip_protocol = "tcp"
    to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "rp_lc_https" {
    security_group_id = aws_security_group.rp_lc.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 1024
    ip_protocol = "tcp"
    to_port     = 65535
}

# lambda - deployment

resource "aws_security_group" "lambda_web_deployment" {
    name        = "lambda-web-deployment-sg"
    description = "lambda private web deployment security group"
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = "lambda-web-deployment-sg"
    })
}

resource "aws_vpc_security_group_ingress_rule" "lambda_web_deployment" {
    security_group_id = aws_security_group.lambda_web_deployment.id

    cidr_ipv4   = "10.128.224.0/23"
    from_port   = 1024
    ip_protocol = "tcp"
    to_port     = 65535
}

resource "aws_security_group_rule" "lambda_web_egress_443" {
    security_group_id = aws_security_group.lambda_web_deployment.id
    type              = "egress"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
}

resource "aws_security_group_rule" "lambda_web_egress_general" {
    security_group_id = aws_security_group.lambda_web_deployment.id
    type              = "egress"
    from_port         = 1024
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks = [
        "10.128.224.0/23"
    ]
}
