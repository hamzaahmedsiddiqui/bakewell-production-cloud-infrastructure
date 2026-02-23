variable "project_name" {}
variable "environment" {}
variable "image_url" {}
variable "db_host" {}
variable "db_user" {}
variable "db_password" { sensitive = true }
variable "db_name" {}
variable "execution_role_arn" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "log_group_name" {
  type = string
}