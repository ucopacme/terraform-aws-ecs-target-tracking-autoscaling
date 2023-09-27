variable "name" {
  description = "Name of the ECS Policy created, will appear in Auto Scaling under Service in ECS"
  type        = string
}

variable "resource_id" {
  description = "Scalable target resource id, either from resource `ECS name` or from `ecs service name` module"
  type        = string
}

variable "target_cpu_value" {
  description = "Autoscale when CPU Usage value over the specified value. Must be specified if `enable_cpu_based_autoscaling` is `true`."
  type        = number

}

variable "target_memory_value" {
  description = "Autoscale when Memory Usage value over the specified value. Must be specified if `enable_memory_based_autoscaling` is `true`."
  default     = null
  type        = number
}

variable "enable_cpu_based_autoscaling" {
  description = "Enable Autoscaling based on ECS Service CPU Usage"
  default     = false
  type        = bool
}

variable "enable_memory_based_autoscaling" {
  description = "Enable Autoscaling based on ECS Service Memory Usage"
  default     = false
  type        = bool
}
variable "enable_alb_based_autoscaling" {
  description = "Enable Autoscaling based on ECS Service alb Usage"
  default     = false
  type        = bool
}

variable "enable_scheduled_scale_in" {
  description = "Enable scale-in to min_capacity at a scheduled time"
  default     = false
  type        = bool
}

variable "scheduled_scale_in_schedule" {
  description = "A time at which to scale in task count to min_capacity"
  type        = string
  default     = "cron(30 2 ? * SUN *)"
}

variable "scheduled_scale_in_max_capacity_reset_schedule" {
  description = "A time at which to reset max_capacity to usual value"
  type        = string
  default     = "cron(40 2 ? * SUN *)"
}

variable "scheduled_scale_in_timezone" {
  description = "Timezone for scheduled_scale_in"
  type        = string
  default     = "US/Pacific"
}

variable "scale_in_cooldown" {
  description = "Time between scale in action"
  default     = 300
  type        = number
}

variable "scale_out_cooldown" {
  description = "Time between scale out action"
  default     = 300
  type        = number
}

variable "disable_scale_in" {
  description = "Disable scale-in action, defaults to false"
  default     = false
  type        = bool
}
variable "target_value" {
  description = "Requests per target in target group metrics to trigger scaling activity"
  type        = number
  default     = 60
}
variable "max_capacity" {
  description = "Max capacity to scale out"
  type        = number
  default     = 1
}
variable "min_capacity" {
  description = "Min capacity to scale in"
  type        = number
  default     = 1
}
variable "alb_arn_suffix" {
  description = "ARN Suffix (not full ARN) of the Application Load Balancer for use with CloudWatch. Output attribute from LB resource: `arn_suffix`"
  type        = string
  default     = ""
}

variable "target_group_arn_suffix" {
  description = "ALB Target Group ARN Suffix (not full ARN) for use with CloudWatch. Output attribute from Target Group resource: `arn_suffix`"
  type        = string
  default     = ""
}
