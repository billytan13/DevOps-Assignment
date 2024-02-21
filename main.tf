terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-southeast-1"
}

data "external" "get_cidr" {
  program = ["bash", "${path.module}/get_cidr.sh"]
}


locals {
  ip_address   = data.external.get_cidr.result.ip_address
  subnet_size  = data.external.get_cidr.result.subnet_size
}

resource "aws_instance" "app_server" {
  ami           = "ami-07a6e3b1c102cdba8"
  instance_type = "t2.micro"


   subnet_id     = aws_subnet.subnet[0].id  # Using the first subnet

  tags = {
    Name = "pythonDevOps"
  }
}


resource "aws_vpc" "main" {
 cidr_block = "${local.ip_address}${local.subnet_size}"
  enable_dns_support = true
  enable_dns_hostnames = true
}


resource "aws_subnet" "subnet" {
  count = 3  # Number of subnets
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index * 8)  # /24 subnets
  availability_zone = "ap-southeast-1a"  
}