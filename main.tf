# Configuración del proveedor AWS y región
provider "aws" {
  region = var.aws_region
}

# Backend S3 para el estado de Terraform (opcional pero recomendado para producción)
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket" # Cambiar por un bucket real
#     key            = "acme/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "your-terraform-state-lock" # Tabla DynamoDB para bloqueo de estado
#     encrypt        = true
#   }
# }

# Carga la configuración de la red
module "network" {
  source = "./modules/network"

  project_name        = var.project_name
  environment         = var.environment
  owner               = var.owner
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  aws_region          = var.aws_region
  availability_zones  = var.availability_zones
}

# Carga la configuración de seguridad
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner
  vpc_id       = module.network.vpc_id
}

# Carga la configuración de IAM
module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner
}

# Carga la configuración de servicios
module "services" {
  source = "./modules/services"

  project_name              = var.project_name
  environment               = var.environment
  owner                     = var.owner
  public_subnet_id          = module.network.public_subnet_ids[0] # Asume la primera subred pública
  private_subnet_id         = module.network.private_subnet_ids[0] # Asume la primera subred privada
  vpc_id                    = module.network.vpc_id
  bastion_security_group_id = module.security.bastion_security_group_id
  ec2_security_group_id     = module.security.ec2_security_group_id
  iam_ec2_role_arn          = module.iam.ec2_s3_cloudwatch_ssm_role_arn
  key_pair_name             = var.key_pair_name
}
