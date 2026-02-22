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
  source            = "./modules/compute"
  project_name      = var.project_name
  environment       = var.environment
  private_subnet_id = module.vpc.private_subnet_ids[0]
  backend_sg_id     = module.security.backend_sg_id
}