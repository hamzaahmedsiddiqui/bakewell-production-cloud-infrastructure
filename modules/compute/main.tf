
#fetch latest Amazon Linux
data "aws_ami" "amazon_linux" {
  most_recent      = true
  owners           = ["amazon"]
  
filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Launch EC2 instance using launch template
resource "aws_launch_template" "backend" {
  name_prefix   = "${var.project_name}-${var.environment}-backend-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.small"

  vpc_security_group_ids = [var.backend_sg_id]
    
  iam_instance_profile {
    name = var.instance_profile_name
        }
  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    
    tags = {
      Name = "${var.project_name}-${var.environment}-backend"
    }
  }
}

# Create an Auto Scaling Group to manage the EC2 instance
resource "aws_autoscaling_group" "backend" {
  desired_capacity     = 0
  max_size             = 2
  min_size             = 0

  vpc_zone_identifier  = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-backend"
    propagate_at_launch = true
  }
}