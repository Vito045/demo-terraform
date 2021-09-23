variable "ami-id" {
  type = string
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

variable "name-1" {
  type = string
  default = "Server 1"
}

variable "nameus-1" {
  type = string
  default = "Server 1"
}
variable "name-2" {
  type = string
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

variable "ports_in_server-1" {
  type    = list(number)
  default = [
    443,
    80,
    22
  ]
}
variable "ports_in_server-2" {
  type    = list(number)
  default = [
    # 443,
    22,
    80
  ]
}


variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default = "10.1.0.0/24"
}
variable "availability_zone" {
  description = "availability zone to create subnet"
  default = "us-east-1a"
}
variable "public_key_path" {
  description = "Public key path"
  default = "~/.ssh/id_rsa.pub"
}
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
  default = "Production"
}

variable "eli_name" {
  description = "Name of Elastic IP instance"
  default = "IP"
}