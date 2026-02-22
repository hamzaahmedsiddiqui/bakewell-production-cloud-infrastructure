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
  source = "./modules/compute"
  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids
  backend_sg_id      = module.security.backend_sg_id
  target_group_arn   = module.alb.target_group_arn
}

module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security.rds_sg_id
}

module "alb" {
  source              = "./modules/alb"
  project_name        = var.project_name
  environment         = var.environment
  public_subnet_ids   = module.vpc.public_subnet_ids
  alb_sg_id           = module.security.alb_sg_id
  vpc_id              = module.vpc.vpc_id
}

module "artifacts" {
  source = "./modules/s3-artifacts"

  project_name = var.project_name
  environment  = var.environment
}