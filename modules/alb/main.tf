# create ALB in public subnets
resource "aws_lb" "this" {
  name               = "${var.project_name}-${var.environment}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.alb_sg_id]

  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
}

# Create a target group for the backend EC2 instance
resource "aws_lb_target_group" "this" {
  name     = "${var.project_name}-${var.environment}-tg"
  port     = 5050
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Attach EC2 to Target Group
# resource "aws_lb_target_group_attachment" "this" {
#   target_group_arn = aws_lb_target_group.this.arn
#   target_id        = var.backend_instance_id
#   port             = 5050
# }

#Create Listener for ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}