resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-${var.environment}-cluster"

  tags = {
    Name        = "${var.project_name}-${var.environment}-ecs-cluster"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/bakewell-prod"
  retention_in_days = 7

  tags = {
    Environment = "prod"
    Project     = "bakewell"
  }
}