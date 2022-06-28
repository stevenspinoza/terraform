resource "aws_security_group" "myapp-sg" {
  vpc_id      = var.vpc_id
  name = "myapp-sg"

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
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
  }

  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}

data "aws_ami" "latest-aws-linux-img" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.my_image]
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
	subnet_id = var.subnet_id
	vpc_security_group_ids = [aws_security_group.myapp-sg.id]
	availability_zone = var.avail_zone
	associate_public_ip_address = true
	key_name = aws_key_pair.myapp-ssh-key.key_name

  user_data = file("modules/webserver/entry-script.sh")

  tags = {
    Name = "${var.env_prefix}-server"
  }
}