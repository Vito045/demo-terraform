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
  email = "vito045@icloud.com"
  token = file("../cloudflare_token.txt")
}

resource "aws_eip" "lb" {
  instance = aws_instance.server-1.id
  vpc      = true

  tags = {
    Name = var.eli_name
  }
}


resource "aws_instance" "server-1" {
  ami = var.ami-id
  # key_name               = aws_key_pair.deployer.key_name
  instance_type = var.instance-type
  key_name      = "terraform"
  # public_ip = aws_eip.react.public_ip


  # subnet_id = "${aws_subnet.subnet_public.id}"
  # vpc_security_group_ids = [aws_security_group.sg_ssh.id, aws_security_group.open_port.id, aws_security_group.https.id]
  vpc_security_group_ids = [aws_security_group.server-1_security_group.id]


  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      # user        = "ubuntu"
      private_key = file("../terraform.pem")
      # host = self.public_ip
      # agent = false
      timeout = "4m"
      host    = aws_instance.server-1.public_dns
    }

    # connection {
    #   type        = "ssh"
    #   # user        = "ec2-user"
    #   user        = "root"
    #   private_key = "${file("~/.ssh/id_rsa")}"
    #   agent       = false
    #   timeout     = "30s"
    #   # host        = aws_instance.server-1.public_ip
    #   host        = aws_instance.server-1.public_dns
    # }


    inline = [
      # "touch ${aws_instance.server-1.public_ip}.txt",
      # "sudo yum remove docker -y",
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo docker container run -d -p 0.0.0.0:80:80 --name react --env BACKEND_SERVER_IP=${aws_instance.server-2.public_ip} vito045/frontend",
      # "sudo docker container run -d -p 0.0.0.0:80:80 --name react vito045/client",
      # "sudo docker container exec -it react bash -c 'echo REACT_APP_API_ADDRESS=${aws_instance.server-2.public_ip} >> .env'"
    ]
  }



  tags = {
    Name = var.name-1
    # drift_example = "v1"
  }
}

resource "aws_instance" "server-2" {
  ami           = var.ami-id
  instance_type = var.instance-type
  # vpc_security_group_ids = [aws_security_group.server-1_security_group.id]
  vpc_security_group_ids = [aws_security_group.server-2_security_group.id]
  key_name               = "terraform"

  # subnet_id = "${aws_subnet.subnet_public.id}"

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("../terraform.pem")
      # agent = false
      timeout = "4m"
      host    = aws_instance.server-2.public_dns
    }
    inline = [
      # "sudo yum remove docker -y",
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo docker container run -d -p 0.0.0.0:80:4000 vito045/server"
    ]
  }

  tags = {
    Name = var.name-2
  }
}

resource "aws_security_group" "server-1_security_group" {
  name = "server-1_security_group"
  # vpc_id = "${aws_vpc.vpc.id}"

  dynamic "ingress" {
    for_each = toset(var.ports_in_server-1)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # ingress {
  #   from_port = 80
  #   to_port = 80
  #   protocol = "tcp"
  #   cidr_blocks = ["${aws_instance.server-1.public_id}/32"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "server-2_security_group" {
  name        = "server-2_security_group"
  description = "Security rule for backend"
  # vpc_id = "${aws_vpc.vpc.id}"

  dynamic "ingress" {
    for_each = toset(var.ports_in_server-2)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      # cidr_blocks = ["${aws_instance.server-1.public_ip}/32"]
    }
  }

  # ingress = [
  #   {

  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["${aws_instance.server-1.public_ip}/32"]
  # }
  # ]

  # provisioner "remote-exec" {
  #   ingress = {
  #     from_port   = 8080
  #     to_port     = 8080
  #     protocol    = "tcp"
  #     cidr_blocks = ["${aws_instance.server-1.public_ip}/0"]
  #   }
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "backend" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "-1"
  # cidr_blocks       = ["${aws_instance.server-1.public_ip}/32"]
  # cidr_blocks       = ["${aws_eip.lb.public_ip}/32"]
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.server-2_security_group.id
}



# resource "null_resource" "server-2" {}
# resource "null_resource" "server-1" {

# }








# resource "aws_vpc" "vpc" {
#   cidr_block = "${var.cidr_vpc}"
#   enable_dns_support   = true
#   enable_dns_hostnames = true
#   tags = {
#     Environment = "${var.environment_tag}"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = "${aws_vpc.vpc.id}"
#   tags = {
#     Environment = "${var.environment_tag}"
#   }
# }

# resource "aws_subnet" "subnet_public" {
#   vpc_id = "${aws_vpc.vpc.id}"
#   cidr_block = "${var.cidr_subnet}"
#   map_public_ip_on_launch = "true"
#   availability_zone = "${var.availability_zone}"
#   tags = {
#     Environment = "${var.environment_tag}"
#   }
# }

# resource "aws_route_table" "rtb_public" {
#   vpc_id = "${aws_vpc.vpc.id}"
#   route {
#       cidr_block = "0.0.0.0/0"
#       gateway_id = "${aws_internet_gateway.igw.id}"
#   }
#   tags = {
#     Environment = "${var.environment_tag}"
#   }
# }

# resource "aws_route_table_association" "rta_subnet_public" {
#   subnet_id      = "${aws_subnet.subnet_public.id}"
#   route_table_id = "${aws_route_table.rtb_public.id}"
# }
