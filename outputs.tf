output "ec2_instance_frontend" {
  description = "ID of client instance"
  value       = aws_instance.frontend.id
}

output "ec2_instance_backend" {
  description = "ID of server instance"
  value       = aws_instance.backend.id
}


# output "public_ip_address-1" {
#   # description = "Public IP address of EC2 instance ${var.name-1}"
#   value = aws_instance.server-1.public_ip
# }

# output "public_ip_address-2" {
#   value = aws_instance.server-2.public_ip
# }


# output "public_dns_address-1" {
#   value = aws_instance.server-1.public_dns
# }


# output "private_ip_address-1" {
#   value = aws_instance.server-1.private_ip
# }

# output "private_ip_address-2" {
#   value = aws_instance.server-2.private_ip
# }

# output "eli_public_dns" {
#   value = aws_eip.lb.public_dns
# }

# output "eli_public_ip" {
#   value = aws_eip.lb.public_ip
# }
