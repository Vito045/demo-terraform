terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.1.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAYMJIZ6GH363RHNRP"
  secret_key = file("../secret_key.txt")
}

provider "cloudflare" {
  email     = "vito045@icloud.com"
  api_token = file("../cloudflare_api_key.txt")

}

resource "aws_instance" "frontend" {
  ami           = var.ami-id
  instance_type = var.instance-type
  key_name      = "terraform"

  vpc_security_group_ids = [aws_security_group.frontend_security_group.id]

  provisioner "remote-exec" {
    connection {
      type    = "ssh"
      user    = "ec2-user"
      host    = self.public_dns
      timeout = "4m"

      private_key = file("../terraform.pem")
    }

    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      # "sudo docker container run -d -p 0.0.0.0:80:80 --name react --env BACKEND_SERVER_IP=${aws_instance.backend.public_ip} vito045/frontend",
      "sudo docker container run -d -p 0.0.0.0:80:80 --name react --env BACKEND_SERVER_IP=https://${var.backend_domain} vito045/frontend",
    ]
  }



  tags = {
    Name = var.frontend_name
  }
}

resource "aws_instance" "backend" {
  ami                    = var.ami-id
  instance_type          = var.instance-type
  vpc_security_group_ids = [aws_security_group.backend_security_group.id]
  key_name               = "terraform"

  provisioner "remote-exec" {
    connection {
      type    = "ssh"
      user    = "ec2-user"
      host    = self.public_dns
      timeout = "4m"

      private_key = file("../terraform.pem")
    }

    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo docker container run -d -p 0.0.0.0:80:4000 vito045/backend"
    ]
  }

  tags = {
    Name = var.backend_name
  }
}
