
resource "aws_appautoscaling_target" "this" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/kk-dev-cluster/kk-dev-service"
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
