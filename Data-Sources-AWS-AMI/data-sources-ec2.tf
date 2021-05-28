terraform {
  required_version = ">=0.14"
}

provider "aws" {
  region = "ap-south-1"
  profile = "Terraform"
}

data "aws_ami" "rhel8_ami" {
  most_recent = true 
  owners = ["amazon", "309956199498"]

  filter {
      name = "name"
      values = ["RHEL_HA*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
      name   = "architecture"
      values = ["x86_64"]
  }

  filter {
      name   = "root-device-type"
      values = ["ebs"]
  }
  
}

output "ami_ids" {
  value = data.aws_ami.rhel8_ami
}

resource "aws_instance" "Terraform-Data-Source-EC2-Instance" {

    ami = data.aws_ami.rhel8_ami.image_id
    instance_type = "t2.micro"

    tags = {
      "Name" = "Terraform-Data-Source-EC2-Instance"
    }
}