resource "aws_codedeploy_app" "this" {
  compute_platform = "ECS"
  name = var.app_name
}

resource "aws_codedeploy_deployment_group" "dev" {
  depends_on = [
    aws_codedeploy_app.this
  ]
  app_name              = var.app_name
  deployment_config_name = var.deployment_config_name
  deployment_group_name = var.deployment_group_name
  service_role_arn      = local.codedeploy_role_arn

  auto_rollback_configuration {
    enabled = var.auto_rollback_configuration["enabled"]
    events  = var.auto_rollback_configuration["events"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = var.blue_green_deployment_config.deployment_ready_option["action_on_timeout"]
    }

    terminate_blue_instances_on_deployment_success {
      action                           = var.blue_green_deployment_config["terminate_blue_instances_on_deployment_success"]["action"]
      termination_wait_time_in_minutes = var.blue_green_deployment_config["terminate_blue_instances_on_deployment_success"]["termination_wait_time_in_minutes"]
    }
  }

  deployment_style {
    deployment_option = var.deployment_style.deployment_option
    deployment_type   = var.deployment_style.deployment_type
  }

  ecs_service {
    cluster_name = var.ecs_service.cluster_name
    service_name = var.ecs_service.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [local.listener_arn]
      }

      target_group {
        name = var.lb_tg_blue_name
      }

      target_group {
        name = var.lb_tg_green_name
      }
    }
  }

}
