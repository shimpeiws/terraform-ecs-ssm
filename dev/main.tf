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
