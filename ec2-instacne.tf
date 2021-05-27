terraform {
  required_version = ">=0.14"
}

provider "aws" {
  region  = "ap-south-1"
  profile = "Terraform"
}