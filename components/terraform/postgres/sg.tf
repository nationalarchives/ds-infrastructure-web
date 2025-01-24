resource "aws_security_group" "postgres_frontend" {
    name        = "postgres-frontend"
    description = "allow postgres access"
    vpc_id      = var.vpc_id

    ingress {
        description = "access from subnets"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = var.source_ingress_cidrs
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
