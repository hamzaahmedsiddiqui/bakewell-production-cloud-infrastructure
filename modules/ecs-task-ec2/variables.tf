variable "project_name" {}
variable "environment" {}
variable "image_url" {}
variable "db_host" {}
variable "db_user" {}
variable "db_password" { sensitive = true }
variable "db_name" {}