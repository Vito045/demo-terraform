variable "ami-id" {
  type    = string
  default = "ami-087c17d1fe0178315" // Amazon
  # default = "ami-09e67e426f25ce0d7" // Ubuntu 20
}

variable "iam-instance-profile" {
  default = ""
  type    = string
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

variable "frontend_name" {
  type    = string
  default = "Server 1"
}

variable "backend_name" {
  type    = string
  default = "Server 2"
}

# variable "key-pair" {
#   type = string
# }

# variable "private-ip" {
#   default = ""
#   type    = string
# }

# variable "subnet-id" {
#   type = string
# }

# variable "vpc-security-group-ids" {
#   type    = list(string)
#   default = []
# }

variable "ports_in_frontend" {
  type = list(number)
  default = [
    443,
    80,
    22
  ]
}
variable "ports_in_backend" {
  type = list(number)
  default = [
    443,
    22,
    # 80
  ]
}


# variable "cidr_vpc" {
#   description = "CIDR block for the VPC"
#   default     = "10.1.0.0/16"
# }
# variable "cidr_subnet" {
#   description = "CIDR block for the subnet"
#   default     = "10.1.0.0/24"
# }
# variable "availability_zone" {
#   description = "availability zone to create subnet"
#   default     = "us-east-1a"
# }
# variable "public_key_path" {
#   description = "Public key path"
#   default     = "~/.ssh/id_rsa.pub"
# }
# variable "instance_ami" {
#   description = "AMI for aws EC2 instance"
#   default = "ami-0cf31d971a3ca20d6"
# }
# variable "instance_type" {
#   description = "type for aws EC2 instance"
#   default = "t2.micro"
# }

variable "environment_tag" {
  description = "Environment tag"
  default     = "Production"
}

variable "frontend_eli_name" {
  description = "Name of Elastic IP instance"
  default     = "IP"
}

variable "backend_eli_name" {
  description = "Name of Elastic IP instance"
  default     = "IP"
}

# variable "domain" {
#   description = "Domain for the site"
#   default     = "vitaliykhomenko.space"
# }

variable "frontend_domain" {
  description = "Domain of frontend-part"
  default     = "vitaliykhomenko.space"
}

variable "backend_subdomain" {
  description = "Subomain of backend-part"
  default     = "server"
}

variable "backend_domain" {
  description = "Domain of backend-part"
  # default     = "${var.backend_subdomain}.${var.frontend_domain}"
  default = "server.vitaliykhomenko.space"
}


variable "zone_id" {
  default = "14609599593ae7922ea2f534878857e6"
}
