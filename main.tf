provider "aws" {
  region = "us-east-1"  # Change as needed
}

variable "tag" {
  description = "Tag for the resources"
  type        = string
  default     = "Terraform"  # Set a default value or update this as needed
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
  default     = "ami-06b21ccaeff8cd686"
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.31.32.0/20"
}

variable "subnet" {
  description = "Subnet for the resources"
  type        = string
  default     = "subnet-0285c1a6c843aa9e0"
}

variable "vpc" {
  description = "vpc for it use"
  type        = string
  default     = "vpc-0f9bd6a752d53cff6"
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
  vpc_id            = aws_vpc.main.id  # Reference the ID of the VPC created above
  cidr_block        = var.cidr          # Use the same CIDR block
  availability_zone = "us-east-1a"     # Change as needed

  tags = {
    Name = "${var.tag}-subnet"
  }
}

# Create an EC2 Instance
resource "aws_instance" "app" {
  ami           = var.ami_id        # Use the AMI variable
  instance_type = "t2.micro"        # Change as needed
  subnet_id     = aws_subnet.main.id # Reference the ID of the subnet created above

  tags = {
    Name = var.tag
  }
}
