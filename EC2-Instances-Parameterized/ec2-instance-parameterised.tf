terraform {
  required_version = ">=0.14"
}

provider "aws" {
  region  = "ap-south-1"
  profile = "Terraform"
}

variable "instance_name" {
    type = string
    description = "It contains the name of the EC2 Instance!"
    default = "Instance_from_Terraform"
}

variable "instance_type" {
  type = string
  description = "It contains the type of EC2 Instance!"
  default = "t2.micro"
}

resource "aws_instance" "I1" {
  ami = "ami-010aff33ed5991201"
  instance_type = var.instance_type

  tags = {
    "Name" = var.instance_name
  }
}