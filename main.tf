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

resource "aws_default_security_group" "default-sg" {
  vpc_id      = aws_vpc.myapp-vpc.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
    #cidr_blocks      = [aws_vpc.myapp-vpc.cidr_block]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    prefix_list_ids = []
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}

data "aws_ami" "latest-aws-linux-img" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_key_pair" "myapp-ssh-key" {
	key_name = "myapp-ssh-key"
	public_key = file(abspath(var.ssh_pub_key_loc))
	# public_key = file(var.ssh_pub_key_loc)
}

resource "aws_instance" "myapp-server" {
  ami           = data.aws_ami.latest-aws-linux-img.id
  instance_type = var.instance_type
	subnet_id = aws_subnet.myapp-sub-1.id
	vpc_security_group_ids = [aws_default_security_group.default-sg.id]
	availability_zone = var.avail_zone
	associate_public_ip_address = true
	key_name = aws_key_pair.myapp-ssh-key.key_name

  tags = {
    Name = "${var.env_prefix}-server"
  }
}
