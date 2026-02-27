# --------------------------------------------------------
# Application Load Balancer (Public)
# --------------------------------------------------------
resource "aws_lb" "this" {
  name               = "${var.project_name}-${var.environment}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.alb_sg_id]

  tags = {
    Name        = "${var.project_name}-${var.environment}-alb"
    Environment = var.environment
    Project     = var.project_name
  }
}

# --------------------------------------------------------
# Target Group (For ECS awsvpc Tasks)
# --------------------------------------------------------
resource "aws_lb_target_group" "this" {
  name        = "${var.project_name}-${var.environment}-tg-v2"
  port        = 5050
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-tg"
    Environment = var.environment
    Project     = var.project_name
  }
}

# --------------------------------------------------------
# Listener
# --------------------------------------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}