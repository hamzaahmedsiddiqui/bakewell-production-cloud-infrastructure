#fetch latest Amazon Linux
data "aws_ami" "amazon_linux" {
  executable_users = ["self"]
  most_recent      = true
  name_regex       = "^myami-[0-9]{3}"
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

# Create EC2 instance in private subnet
resource "aws_instance" "backend" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.backend_sg_id]
  associate_public_ip_address = false

  tags = {
    Name = "${var.project_name}-${var.environment}-backend"
  }
}