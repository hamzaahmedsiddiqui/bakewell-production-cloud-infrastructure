# Create a DB subnet group for RDS instances
resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

# Create RDS Instance
resource "aws_db_instance" "this" {
  identifier              = "${var.project_name}-${var.environment}-db"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_encrypted       = true

  username                = "bakewelladmin"
  password                = var.db_password   # Later we use secrets manager
  db_name                 = "bakewell_dev"

  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.rds_sg_id]

  publicly_accessible     = false
  skip_final_snapshot     = true

  tags = {
    Name = "${var.project_name}-${var.environment}-db"
  }
}