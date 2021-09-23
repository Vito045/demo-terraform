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
