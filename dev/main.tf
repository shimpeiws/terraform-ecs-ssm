terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

terraform {
  required_version = "~> 1.5.0"

  backend "s3" {
    bucket = "shimpeiws-terraform-ecs-ssm"
    key    = "dev/terraform.tfstate"
  }
}

module "vpc" {
  source      = "../modules/vpc"
  env_name    = "dev"
}

module "iam_role" {
  source      = "../modules/iam_role"
  env_name    = "dev"
}

module "ecs" {
  source      = "../modules/ecs"
  env_name    = "dev"
  image_uri    = var.image_uri
  iam_role_arn = module.iam_role.iam_role_arn
  security_group_id = module.vpc.security_group_id
  subnet_public_0 = module.vpc.subnet_public_0
  subnet_private_0 = module.vpc.subnet_private_0
  subnet_private_1 = module.vpc.subnet_private_1
}
