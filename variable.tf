variable vpc_cidr_block {
    default = "10.0.0.0/16"
}
variable subnet_cidr_block {
    default = "10.0.10.0/24"
}
variable avail_zone {
    default = "us-east-1a"
}
variable env_prefix {
    default = "dev"
}

variable "vpc_name" {
    description = "VPC name"
    default = "myapp-vpc"
    type = string
}

variable "vpc_region" {
    description = "VPC region"
    default = "us-east-1"
    type = string
}

variable my_ip {
    default = ""
}

variable instance_type {
    default = "t2.micro"
}

variable ssh_pub_key_loc {}