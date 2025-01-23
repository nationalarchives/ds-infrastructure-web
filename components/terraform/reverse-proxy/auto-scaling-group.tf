resource "aws_autoscaling_group" "rp" {
    name = "web-rp"
    launch_template {
        id      = aws_launch_template.reverse_proxy.id
        version = "$Latest"
    }

    vpc_zone_identifier = [
        var.private_subnet_a_id,
        var.private_subnet_b_id
    ]

    max_size                  = var.asg_max_size
    min_size                  = var.asg_min_size
    desired_capacity          = var.asg_desired_capacity
    health_check_grace_period = var.asg_health_check_grace_period
    health_check_type         = var.asg_health_check_type

    lifecycle {
        create_before_destroy = true
        ignore_changes        = [
            load_balancers,
            target_group_arns
        ]
    }

    dynamic "tag" {
        for_each = var.asg_tags
        content {
            key                 = tag.value["key"]
            value               = tag.value["value"]
            propagate_at_launch = tag.value["propagate_at_launch"]
        }
    }
}

resource "aws_autoscaling_attachment" "rp" {
    autoscaling_group_name = aws_autoscaling_group.rp.id
    lb_target_group_arn    = aws_lb_target_group.rp_public.arn
}
