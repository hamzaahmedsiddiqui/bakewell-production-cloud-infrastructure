variable "project_name" {}
variable "environment" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "rds_sg_id" {}
variable "db_password" {
  sensitive = true
}