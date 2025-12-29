# Scale In Policy
resource "aws_autoscaling_policy" "scale_in" {
  count                  = var.enable_autoscaling ? 1 : 0
  name                   = "${var.web_catalogue_autoscaling_policy_name_prefix}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.web_catalogue.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = var.default_cooldown
}

# CloudWatch Alarm for Scale In
resource "aws_cloudwatch_metric_alarm" "scale_in" {
  count                  = var.enable_autoscaling ? 1 : 0
  alarm_description      = "Scaling in - CPU utilisation < ${var.scale_in_threshold}% - ${var.web_catalogue_autoscaling_policy_name_prefix} ASG"
  alarm_actions          = [aws_autoscaling_policy.scale_in[0].arn]
  alarm_name             = "${var.web_catalogue_autoscaling_policy_name_prefix}-scale-in"
  comparison_operator    = "LessThanThreshold"
  insufficient_data_actions = []
  threshold              = var.scale_in_threshold
  evaluation_periods     = 5

  metric_query {
    id          = "e_avg"
    expression  = "IF(instance_count > instance_min, cpu_avg, ${var.scale_in_threshold})"
    label       = "CPU Utilization"
    return_data = true
  }

  metric_query {
    id          = "cpu_avg"
    return_data = false
    metric {
      dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.web_catalogue.name
      }
      metric_name = "CPUUtilization"
      namespace   = "AWS/EC2"
      period      = 60
      stat        = "Average"
    }
  }

  metric_query {
    id          = "instance_min"
    return_data = false
    metric {
      dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.web_catalogue.name
      }
      metric_name = "GroupMinSize"
      namespace   = "AWS/AutoScaling"
      period      = 60
      stat        = "Average"
    }
  }

  metric_query {
    id          = "instance_count"
    return_data = false
    metric {
      dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.web_catalogue.name
      }
      metric_name = "GroupInServiceInstances"
      namespace   = "AWS/AutoScaling"
      period      = 60
      stat        = "Average"
    }
  }
}

# Scale Out Policy
resource "aws_autoscaling_policy" "scale_out" {
  count                  = var.enable_autoscaling ? 1 : 0
  name                   = "${var.web_catalogue_autoscaling_policy_name_prefix}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.web_catalogue.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = var.default_cooldown
}

# CloudWatch Alarm for Scale Out
resource "aws_cloudwatch_metric_alarm" "scale_out" {
  count                  = var.enable_autoscaling ? 1 : 0
  alarm_description      = "Scaling out - CPU utilisation >= ${var.scale_out_threshold}% - ${var.web_catalogue_autoscaling_policy_name_prefix} ASG"
  alarm_actions          = [aws_autoscaling_policy.scale_out[0].arn]
  alarm_name             = "${var.web_catalogue_autoscaling_policy_name_prefix}-scale-out"
  comparison_operator    = "GreaterThanOrEqualToThreshold"
  insufficient_data_actions = []
  namespace              = "AWS/EC2"
  metric_name            = "CPUUtilization"
  threshold              = var.scale_out_threshold
  evaluation_periods     = 5
  period                 = 60
  statistic              = "Average"
  unit                   = "Percent"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_catalogue.name
  }
}
