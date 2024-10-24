provider "aws" {
  region = "us-east-1"  # Change as needed
}

variable "tag" {
  description = "Tag for the resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet" {
  description = "Subnet for the resources"
  type        = string
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr

  tags = {
    Name = var.tag
  }
}

# Create a Subnet
resource "aws_subnet" "main" {
  vpc_id            = vpc-0f9b21ccaeff8cd686
  cidr_block        = 172.31.32.0/20
  availability_zone = "us-east-1a"  # Change as needed

  tags = {
    Name = "${var.tag}-subnet"
  }
}

# Create an EC2 Instance
resource "aws_instance" "app" {
  ami           = ami-06b21ccaeff8cd686
  instance_type = "t2.micro"  # Change as needed
  subnet_id     = subnet-0285c1a6c843aa9e0

  tags = {
    Name = var.tag
  }
}
