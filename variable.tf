variable "vpc_name" {
    description = "VPC name"
    default = "terra-vpc"
    type = string
}

variable "vpc_region" {
    description = "VPC region"
    default = "us-east-1"
    type = string
}

variable "avail_zone_1" {
    description = "Availability_zone 1"
    default = "us-east-1a"
    type = string
}

variable "avail_zone_2" {
    description = "Availability_zone 2"
    default = "us-east-1b"
    type = string
}

variable "cidr_blocks" {
    description = "VPC CIDR blocks"
    type = list(object({
        cidr_block = string
        name = string
    }))	
}