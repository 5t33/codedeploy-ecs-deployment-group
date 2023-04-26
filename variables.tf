variable "app_name" {
  type = string
}

variable "alb_name" {
  type = string
}

variable "alb_port" {
  type = number
} 

variable "deployment_group_name" {
  type = string
}

variable "deployment_config_name" {
  type = string
  default = "CodeDeployDefault.ECSAllAtOnce"
}

variable "role_name" {
  type = string
}

variable "lb_tg_blue_name" {
  type = string
}

variable "lb_tg_green_name" {
  type = string
}

variable "auto_rollback_configuration" {
  type = object({
    enabled = bool
    events = list(string)
  })
  default = {
    enabled = true
    events = ["DEPLOYMENT_FAILURE"]
  }
}

variable "blue_green_deployment_config" {
  type = object({
    deployment_ready_option = object({
      action_on_timeout = string
    })
    terminate_blue_instances_on_deployment_success = object({
      action = string
      termination_wait_time_in_minutes = number
    })
  })
  default = {
    deployment_ready_option = {
       action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success = {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }
}


variable "ecs_service" {
  type = object({
    cluster_name = string
    service_name = string
  })
}

variable "deployment_style" {
  type = object({
    deployment_option = string
    deployment_type = string
  })
  default = {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
}