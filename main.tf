resource "aws_appautoscaling_target" "this" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = var.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

#------------------------------------------------------------------------------
# AWS Auto Scaling - ALB Request Count per Target
#------------------------------------------------------------------------------
resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = join("-", [var.name, "alb"])
  count              = var.enable_alb_based_autoscaling ? 1 : 0
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = var.target_value
    disable_scale_in   = var.disable_scale_in
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown

    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
        resource_label         = "${var.alb_arn_suffix}/${var.target_group_arn_suffix}"
    }
  }
}

#------------------------------------------------------------------------------
# AWS Auto Scaling - CPU Utilization
#------------------------------------------------------------------------------
resource "aws_appautoscaling_policy" "ecs_service_cpu_policy" {
  count              = var.enable_cpu_based_autoscaling ? 1 : 0
  name               = join("-", [var.name, "cpu"])
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = var.target_cpu_value
    disable_scale_in   = var.disable_scale_in
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

#------------------------------------------------------------------------------
# AWS Auto Scaling - Memory Utilization
#------------------------------------------------------------------------------
resource "aws_appautoscaling_policy" "ecs_service_memory_policy" {
  count              = var.enable_memory_based_autoscaling ? 1 : 0
  name               = join("-", [var.name, "memory"])
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = var.target_memory_value
    disable_scale_in   = var.disable_scale_in
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}

#------------------------------------------------------------------------------
# AWS Auto Scaling - Scheduled scale-in
#------------------------------------------------------------------------------
resource "aws_appautoscaling_scheduled_action" "ecs_service_scheduled_scale_in" {
  count              = var.enable_scheduled_scale_in ? 1 : 0
  name               = join("-", [var.name, "scheduled-scale-in"])
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  schedule           = var.scheduled_scale_in_schedule
  timezone           = var.scheduled_scale_in_timezone

  scalable_target_action {
    min_capacity = var.min_capacity
    max_capacity = var.min_capacity
  }
}

resource "aws_appautoscaling_scheduled_action" "ecs_service_scheduled_scale_in_max_capacity_reset" {
  count              = var.enable_scheduled_scale_in ? 1 : 0
  name               = join("-", [var.name, "scheduled-scale-in-max-capacity-reset"])
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  schedule           = var.scheduled_scale_in_max_capacity_reset_schedule
  timezone           = var.scheduled_scale_in_timezone

  scalable_target_action {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }
}
