
resource "aws_eip" "frontend" {
  instance = aws_instance.frontend.id

  tags = {
    Name = var.frontend_eli_name
  }
}

resource "aws_eip" "backend" {
  instance = aws_instance.backend.id

  tags = {
    Name = var.backend_eli_name
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
  protocol  = "tcp"
  # cidr_blocks = ["${aws_instance.frontend.public_ip}/32"]
  # cidr_blocks       = ["${aws_eip.lb.public_ip}/32"]
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backend_security_group.id
}
