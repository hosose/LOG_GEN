# CloudWatch Log Group for ECS Fargate logs
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${local.name_prefix}"
  retention_in_days = var.log_retention_in_days

  tags = {
    Name = "${local.name_prefix}-log-group"
  }
}
