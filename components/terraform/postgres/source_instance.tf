resource "aws_instance" "source" {
    ami                         = var.source_ami_id
    associate_public_ip_address = var.source_associate_public_ip_address
    availability_zone           = var.source_availability_zone
    iam_instance_profile        = var.source_iam_instance_profile
    instance_type               = var.source_instance_type
    key_name                    = var.source_key_name
    monitoring                  = var.source_monitoring
    root_block_device {
        delete_on_termination = var.source_root_block_device.delete_on_termination
        encrypted             = var.source_root_block_device.encrypted
        volume_size           = var.source_root_block_device.volume_size
        volume_type           = var.source_root_block_device.volume_type
    }
    subnet_id = aws_security_group.postgres_frontend.id
    vpc_security_group_ids = [
        aws_security_group.postgres_frontend.id
    ]

    tags = merge(var.tags, {
        Name = "web-postgres-source"
    })
}
