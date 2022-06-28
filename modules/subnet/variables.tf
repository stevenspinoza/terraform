variable subnet_cidr_block {
    default = "10.0.10.0/24"
}
variable avail_zone {
    default = "us-east-1a"
}
variable env_prefix {
    default = "dev"
}

variable vpc_id {
    description = "VPC name"
    default = "myapp-vpc"
    type = string
}

variable default_route_table_id {}