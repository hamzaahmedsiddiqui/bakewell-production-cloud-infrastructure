locals {
  instance_profile_name = var.create_iam ? module.iam[0].instance_profile_name : "LabInstanceProfile"
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
  cluster_name          = module.ecs.cluster_name

}

module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security.rds_sg_id
  db_password        = var.db_password
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
  count        = var.create_iam ? 1 : 0
  source       = "./modules/iam"
  project_name = var.project_name
  environment  = var.environment
}

# Note: when you move to a real AWS account, run: terraform apply -var="create_iam=true" 


module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
  environment  = var.environment
}

module "ecs" {
  source       = "./modules/ecs"
  project_name = var.project_name
  environment  = var.environment
}


locals {
  execution_role_arn = var.create_iam ? module.iam[0].ecs_execution_role_arn : null
}
module "ecs_task" {
  source             = "./modules/ecs-task-ec2"
  project_name       = var.project_name
  environment        = var.environment
  image_url          = module.ecr.repository_url
  db_host            = module.rds.db_endpoint
  db_user            = "bakewelladmin"
  db_password        = var.db_password
  db_name            = "bakewell_dev"
  execution_role_arn = local.execution_role_arn
  repository_url     = module.ecr.repository_url
  log_group_name     = module.ecs.log_group_name
}

module "ecs_service" {
  source = "./modules/ecs-service-ec2"

  project_name        = var.project_name
  environment         = var.environment
  cluster_id          = module.ecs.cluster_id
  task_definition_arn = module.ecs_task.task_definition_arn
  target_group_arn    = module.alb.target_group_arn
}

# module "frontend" {
#   source       = "./modules/frontend"
#   project_name = var.project_name
#   environment  = var.environment
#   region       = var.aws_region
# }
