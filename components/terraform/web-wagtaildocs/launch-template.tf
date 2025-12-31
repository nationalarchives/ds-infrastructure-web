# -----------------------------------------------------------------------------
# Launch Template
# -----------------------------------------------------------------------------
resource "aws_launch_template" "web_wagtaildocs" {
    name = "web-wagtaildocs"

    iam_instance_profile {
        arn = aws_iam_instance_profile.web_wagtaildocs_profile.arn
    }

    image_id               = var.ami_id
    instance_type          = var.instance_type
    key_name               = var.key_name
    update_default_version = true

    vpc_security_group_ids = [
        var.web_wagtaildocs_sg_id
    ]

    user_data = base64encode(templatefile("${path.module}/scripts/userdata.sh", {
        mount_target         = var.efs_dns_name,
        web_wagtaildocs_efs_mount_dir            = var.web_wagtaildocs_efs_mount_dir,
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
    monitoring {
        enabled = var.enable_monitoring
    }
}

