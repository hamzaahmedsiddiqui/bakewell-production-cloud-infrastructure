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
  type    = bool
  default = false
}