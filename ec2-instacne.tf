terraform {
  required_version = ">=0.14"
}

provider "aws" {
  region  = "ap-south-1"
  profile = "Terraform"
}

resource "aws_instance" "I1" {
  ami = "ami-010aff33ed5991201"
  instance_type = "t2.micro"

  tags = {
    "Name" = "Resource_From_Terraform"
  }
}