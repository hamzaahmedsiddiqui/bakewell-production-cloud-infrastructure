variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for backend Auto Scaling Group"
  type        = list(string)
}

variable "backend_sg_id" {
  description = "Security group ID attached to backend instances"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN for ALB to register backend instances"
  type        = string
}

variable "instance_profile_name" {
  type = string
}