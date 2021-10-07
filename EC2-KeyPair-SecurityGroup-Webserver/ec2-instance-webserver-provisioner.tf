terraform {
  required_version = ">=0.14"
}

provider "aws" {
  region = "ap-south-1"
  profile = "terraform"
}

resource "tls_private_key" "AWS_KEY" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "aws_key_pair" "Terraform_Key" {
  key_name = "Terraform_Key"
  public_key = tls_private_key.AWS_KEY.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.AWS_KEY.private_key_pem}' > ~/Downloads/AWS_KEY.pem"
  }

  provisioner "local-exec" {
    command = "chmod 400  ~/Downloads/AWS_KEY.pem"
  }

}

resource "aws_security_group" "Webserver_SG" {

  description = "Webserver Security Group!"
  name = "Webserver SG"

  // Created an inbound rule for HTTP Request
  ingress {
    description = "Webserver HTTP Port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Created an inbound rule for SSH Request
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Created an inbound rule for HTTPS Request
  ingress {
    description = "SSH"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "output from MySQL BH"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "InstanceThroughTerraform" {

  depends_on = [
                aws_key_pair.Terraform_Key
  ]

  instance_type = "t2.micro"
  ami = "ami-041d6256ed0f2061c"   // Amazon Linux 2 Image AMI in Mumbai Region
  key_name = aws_key_pair.Terraform_Key.key_name
  vpc_security_group_ids = [aws_security_group.Webserver_SG.id]

  tags = {
    "NAME" = "EC2_Instance_from_Terraform"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = tls_private_key.AWS_KEY.private_key_pem
    host = aws_instance.InstanceThroughTerraform.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }

}

