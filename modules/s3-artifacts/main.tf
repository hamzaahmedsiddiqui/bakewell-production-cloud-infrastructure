# Create an S3 bucket for storing build artifacts
resource "aws_s3_bucket" "this" {
  bucket              = "${var.project_name}-artifacts-${var.environment}"
  object_lock_enabled = false

  tags = {
    Name        = "${var.project_name}-artifacts-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

#   Block all public access to the bucket
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}