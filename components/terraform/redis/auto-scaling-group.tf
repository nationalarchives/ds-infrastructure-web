locals {
    asg_wagtail_redis_tags = concat(var.asg_tags, [
        {
            key                 = "Name"
            value               = "wagtail-redis"
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

resource "aws_autoscaling_group" "wagtail_redis" {
    name = "wagtail-redis"
    launch_template {
        id      = aws_launch_template.wagtail_redis.id
        version = aws_launch_template.wagtail_redis.latest_version
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
        for_each = local.asg_wagtail_redis_tags
        content {
            key                 = tag.value["key"]
            value               = tag.value["value"]
            propagate_at_launch = true
        }
    }
}

resource "aws_autoscaling_attachment" "wagtail_redis" {
    autoscaling_group_name = aws_autoscaling_group.wagtail_redis.id
    lb_target_group_arn    = aws_lb_target_group.wagtail_redis.arn
}

resource "aws_autoscaling_policy" "wagtail_redis_up_policy" {
    name                   = "wagtail-redis-up-policy"
    scaling_adjustment     = 1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    autoscaling_group_name = aws_autoscaling_group.wagtail_redis.name
}

resource "aws_autoscaling_policy" "wagtail_redis_down_policy" {
    name                   = "wagtail-redis-down-policy"
    scaling_adjustment     = -1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    autoscaling_group_name = aws_autoscaling_group.wagtail_redis.name
}
