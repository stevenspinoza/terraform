# terraform {
#     required_version = ">= 0.12"
#     backend "s3" {
#       bucket = "myapp-terra-bucket"
#       key = "myapp/state.tfstate"
#       region = "us-east-1"
#     }
    
# }

provider "aws" {
  # Configuration options
  region = var.vpc_region
	shared_credentials_files = [""]
  profile                 = ""
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs             = [var.avail_zone]
  public_subnets  = [var.subnet_cidr_block]
	public_subnet_tags = {
		Name = "${var.env_prefix}-subnet-1"
	}

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}



