# data source to fetch existing S3 bucket for artifacts
# data "aws_s3_bucket" "artifacts" {
#   bucket = "bakewell-artifacts-prod"
# }

data "aws_iam_instance_profile" "lab" {
  count = var.create_iam ? 0 : 1
  name  = "LabInstanceProfile"
}
locals {
  instance_profile_name = var.create_iam ? module.iam[0].instance_profile_name : data.aws_iam_instance_profile.lab[0].name
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  environment  = var.environment
}

module "security" {
  source       = "./modules/security"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
}

module "compute" {
  source                = "./modules/compute"
  project_name          = var.project_name
  environment           = var.environment
  private_subnet_ids    = module.vpc.private_subnet_ids
  backend_sg_id         = module.security.backend_sg_id
  target_group_arn      = module.alb.target_group_arn
  instance_profile_name = local.instance_profile_name
}

module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security.rds_sg_id
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  environment       = var.environment
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  vpc_id            = module.vpc.vpc_id
}

module "iam" {
  count                = var.create_iam ? 1 : 0
  source               = "./modules/iam"
  project_name         = var.project_name
  environment          = var.environment
  artifacts_bucket_arn = data.aws_s3_bucket.artifacts.arn
}

