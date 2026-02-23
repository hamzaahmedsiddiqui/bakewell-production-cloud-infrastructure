resource "aws_ecr_repository" "this" {
  name = "${var.project_name}-${var.environment}-backend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-backend-ecr"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}