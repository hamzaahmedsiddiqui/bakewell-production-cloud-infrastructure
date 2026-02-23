variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Project name prefix for all resources"
  type        = string
  default     = "bakewell"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "create_iam" {
  type        = bool
  description = "Whether to create IAM roles/policies. In VocLabs this should be false."
  default     = false
}

variable "db_password" {
  description = "Database password for backend"
  type        = string
  sensitive   = true
}