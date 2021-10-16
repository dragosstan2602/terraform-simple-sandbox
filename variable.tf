variable "vpc_cidr_block" {
  type = string
  default = "192.168.0.0/22"
}

variable "region" {
  type = string
  default = "eu-central-1"
}

variable "subnet_cidrs" {
  type = list
  default = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
}

data "aws_availability_zones" "azs" {
  state = "available"
}
