
resource "aws_eip" "frontend" {
  instance = aws_instance.frontend.id
  # vpc      = true

  tags = {
    Name = var.frontend_eli_name
  }
}

resource "aws_eip" "backend" {
  instance = aws_instance.backend.id
  # vpc      = true

  tags = {
    Name = var.backend_eli_name
  }
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
      host    = self.backend.public_dns
      timeout = "4m"

      private_key = file("../terraform.pem")
    }

    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo docker container run -d -p 0.0.0.0:80:4000 vito045/server"
    ]
  }

  tags = {
    Name = var.backend_name
  }
}

resource "aws_security_group" "frontend_security_group" {
  name = "frontend_security_group"

  dynamic "ingress" {
    for_each = toset(var.ports_in_frontend)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend_security_group" {
  name        = "backend_security_group"
  description = "Security rule for backend"

  dynamic "ingress" {
    for_each = toset(var.ports_in_backend)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      # cidr_blocks = ["${aws_instance.frontend.public_ip}/32"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "client-server" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "-1"
  # cidr_blocks = ["${aws_instance.frontend.public_ip}/32"]
  # cidr_blocks       = ["${aws_eip.lb.public_ip}/32"]
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backend_security_group.id
}
