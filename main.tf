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
  region  = "us-east-1"
}

resource "aws_key_pair" "web_key" {
  key_name   = "web-server"
  public_key = file(var.public_key)
}
resource "aws_instance" "web_server" {
  ami           = "ami-083654bd07b5da81d"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.web_key.key_name

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      private_key = file(var.private_key)
      user        = "ubuntu"
      host        = self.public_ip
    }
    inline = ["sudo apt update"]


  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key ${var.private_key} provision.yml"
  }

  tags = {
    Name = "Web-Server"
  }
}
