# -----------------------------------------------------------------------------
# Launch Template
# -----------------------------------------------------------------------------
resource "aws_launch_template" "platform_redis" {
    name = "platform-redis"

    iam_instance_profile {
        arn = aws_iam_instance_profile.platform_redis_profile.arn
    }

    image_id               = var.ami_id
    instance_type          = var.instance_type
    key_name               = var.key_name
    update_default_version = true

    vpc_security_group_ids = [
        var.redis_sg_id
    ]

    user_data = base64encode(templatefile("${path.module}/scripts/userdata.sh", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        nginx_folder_s3_key  = var.folder_s3_key
    }))

    block_device_mappings {
        device_name = "/dev/xvda"

        ebs {
            volume_size = var.root_block_device_size
            encrypted   = true
        }
    }

    metadata_options {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 1
        instance_metadata_tags      = "enabled"
    }
}
