terraform {  
  required_providers {   
    aws = {      
      source  = "hashicorp/aws"      
      version = "~> 3.27"    
    }  
  }
  required_version = ">= 0.14.9"
}

provider "aws" {  
  profile = "default"  
  region  = var.region

#   assume_role {
#     role_arn = "arn:aws:iam:accountID:role/network"
#   }

  max_retries = 2

  default_tags {
      tags = {
        Environment = "HomeLab"
        Division    = "Sandbox"
        Source      = "Terraform-Sandbox"
        Consumer    = "Dragos"
        Application = "CrazyClownSandbox"
      }
  }
}

#######################
# VPC CREATION SECTION
#######################

resource "aws_vpc" "myVPC" {
  cidr_block = "192.168.0.0/22"
  instance_tenancy = "default"

  tags = {
    "Name" = "deec1-terraform-vpc"
  }
}

resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    "Name" = "deec1-public-igw"
  }
}

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "deec1-vpn-gw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    "Name" = "deec1-public-rt"
  }
  
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    "Name" = "deec1-private-rt"
  }
}

##################
# SUBNETS SECTION
##################

resource "aws_subnet" "private_subnets" {
  count = "${length(var.subnet_cidrs)}"
  cidr_block = "${element(var.subnet_cidrs, count.index)}"
  vpc_id = aws_vpc.myVPC.id
  availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"
  
  tags = {
    "Name" = "deec1-private-subnet-0${count.index+1}"
  }
}

resource "aws_route_table_association" "private-subnets-rt-assoc" {
  count = "${length(aws_subnet.private_subnets)}"
  subnet_id = "${element(aws_subnet.private_subnets, count.index)}".id
  route_table_id = aws_route_table.private_rt.id
}

#########
# ROUTES
#########



############
# ENDPOINTS
############
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = aws_vpc.myVPC.id
  service_name = "com.amazonaws.${var.region}.s3"

  tags = {
    "Name" = "deec1-s3-endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "example" {
  route_table_id  = aws_route_table.private_rt.id
  vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
}

##################
# SECURITY GROUPS
##################