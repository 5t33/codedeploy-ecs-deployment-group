data "aws_iam_role" "codedeploy_role" {
  name = var.role_name
}

data "aws_lb" "selected" {
  name = var.alb_name
}

data "aws_lb_listener" "selected" {
  load_balancer_arn = data.aws_lb.selected.arn
  port              = var.alb_port
}

locals {
  codedeploy_role_arn = data.aws_iam_role.codedeploy_role.arn
  listener_arn = data.aws_lb_listener.selected.arn
}