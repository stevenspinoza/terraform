provider "aws" {
  # Configuration options
  region = var.vpc_region
	shared_credentials_files = [""]
  profile                 = ""
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-sub-1" {
  vpc_id     = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
	tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "myapp-igw-1" {
  vpc_id     = aws_vpc.myapp-vpc.id
	tags = {
    Name = "${var.env_prefix}-igw-1"
  } 
}

resource "aws_default_route_table" "example" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw-1.id
  }
	tags = {
    Name = "${var.env_prefix}-main-rtb"
  } 
}