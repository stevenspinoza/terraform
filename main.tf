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

module "myapp-subnet" {
    source = "./modules/subnet"
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.myapp-vpc.id
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

module "myapp-server" {
	 	source = "./modules/webserver"
		vpc_id = aws_vpc.myapp-vpc.id
    my_ip = var.my_ip
    env_prefix = var.env_prefix
    my_image = var.image
    ssh_pub_key_loc = var.ssh_pub_key_loc 
    instance_type = var.instance_type
    subnet_id = module.myapp-subnet.sub-1.id
    avail_zone = var.avail_zone
}


