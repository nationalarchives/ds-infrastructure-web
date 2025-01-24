resource "aws_instance" "replica" {
    ami                         = var.replica_ami_id
    associate_public_ip_address = var.replica_associate_public_ip_address
    availability_zone           = var.replica_availability_zone
    iam_instance_profile        = var.replica_iam_instance_profile
    instance_type               = var.replica_instance_type
    key_name                    = var.replica_key_name
    monitoring                  = var.replica_monitoring
    root_block_device {
        delete_on_termination = var.replica_root_block_device.delete_on_termination
        encrypted             = var.replica_root_block_device.encrypted
        volume_size           = var.replica_root_block_device.volume_size
        volume_type           = var.replica_root_block_device.volume_type
    }
    subnet_id = aws_security_group.postgres_frontend.id
    vpc_security_group_ids = [
        aws_security_group.postgres_frontend.id
    ]

    tags = merge(var.tags, {
        Name = "web-postgres-replica"
    })
}
