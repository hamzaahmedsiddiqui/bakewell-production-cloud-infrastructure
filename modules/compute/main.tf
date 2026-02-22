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

# # Create EC2 instance in private subnet
# resource "aws_instance" "backend" {
#   ami                         = data.aws_ami.amazon_linux.id
#   instance_type               = "t3.micro"
#   subnet_id                   = var.private_subnet_id
#   vpc_security_group_ids      = [var.backend_sg_id]
#   associate_public_ip_address = false

#   tags = {
#     Name = "${var.project_name}-${var.environment}-backend"
#   }
# }

# Launch EC2 instance using launch template
resource "aws_launch_template" "backend" {
  name_prefix   = "${var.project_name}-${var.environment}-backend-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [var.backend_sg_id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-${var.environment}-backend"
    }
  }
}

# Create an Auto Scaling Group to manage the EC2 instance
resource "aws_autoscaling_group" "backend" {
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1

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