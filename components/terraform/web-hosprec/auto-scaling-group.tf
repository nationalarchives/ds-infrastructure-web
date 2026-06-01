locals {
    asg_web_hosprec_tags = concat(var.asg_tags, [
        {
            key                 = "Name"
            value               = "web-hosprec"
        },
        {
            key                 = "AutoSwitchOff"
            value               = var.auto_switch_off
        },
        {
            key                 = "AutoSwitchOn"
            value               = var.auto_switch_on
        },
        {
            key                 = "Patch-Group"
            value               = var.patch_group
        },
        {
            key                 = "Deployment-Group"
            value               = var.deployment_group
        },
        {
            key                 = "DeploymentGroup"
            value               = var.deployment_group
        },
        {
            key                 = "PatchGroup"
            value               = var.patch_group
        },
    ])
}

resource "aws_autoscaling_group" "web_hosprec" {
    name = "web-hosprec"
    launch_template {
        id      = aws_launch_template.web_hosprec.id
        version = aws_launch_template.web_hosprec.latest_version
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

    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]

    metrics_granularity = "1Minute"

    lifecycle {
        create_before_destroy = true
        ignore_changes = [
            load_balancers,
            target_group_arns
        ]
    }

    dynamic "tag" {
        for_each = local.asg_web_hosprec_tags
        content {
            key                 = tag.value["key"]
            value               = tag.value["value"]
            propagate_at_launch = true
        }
    }
}

resource "aws_autoscaling_attachment" "web_hosprec" {
    autoscaling_group_name = aws_autoscaling_group.web_hosprec.id
    lb_target_group_arn    = aws_lb_target_group.web_hosprec.arn
}

resource "aws_autoscaling_policy" "web_hosprec_up_policy" {
    name                   = "web-hosprec-up-policy"
    scaling_adjustment     = 1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    autoscaling_group_name = aws_autoscaling_group.web_hosprec.name
}

resource "aws_autoscaling_policy" "web_hosprec_down_policy" {
    name                   = "web-hosprec-down-policy"
    scaling_adjustment     = -1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    autoscaling_group_name = aws_autoscaling_group.web_hosprec.name
}
