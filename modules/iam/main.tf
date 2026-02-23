# IAM Role for EC2 instances to allow S3 read access if artifacts_bucket_arn is provided
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# Create S3 read policy ONLY if artifacts_bucket_arn is provided
resource "aws_iam_policy" "s3_read_policy" {
  count = var.artifacts_bucket_arn == null ? 0 : 1

  name = "${var.project_name}-${var.environment}-s3-read"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:GetObject"]
      Resource = "${var.artifacts_bucket_arn}/*"
    }]
  })
}

# Attach S3 read policy to EC2 role if it was created
 resource "aws_iam_role" "ecs_execution_role" {
  name = "bakewell-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3" {
  count = var.artifacts_bucket_arn == null ? 0 : 1

  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read_policy[0].arn
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.project_name}-${var.environment}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_logs_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}