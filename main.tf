provider "aws" {
  # Configuration options
  region = var.vpc_region
	shared_credentials_files = [""]
  profile                 = ""
}

resource "aws_vpc" "terra-vpc" {
  cidr_block       = var.cidr_blocks[0].cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "terra-sub-1" {
  vpc_id     = aws_vpc.terra-vpc.id
  cidr_block = var.cidr_blocks[1].cidr_block
	availability_zone = var.avail_zone_1
	tags = {
    Name = var.cidr_blocks[1].name
  }
}

resource "aws_subnet" "terra-sub-2" {
  vpc_id     = aws_vpc.terra-vpc.id
  cidr_block = var.cidr_blocks[2].cidr_block
	availability_zone = var.avail_zone_2
	tags = {
    Name = var.cidr_blocks[2].name
  }
}

output "terra-vpc-id" {
	value = aws_vpc.terra-vpc.id
}

output "terra-vpc-sub-id-1" {
	value = aws_subnet.terra-sub-1.id
}    