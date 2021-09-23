resource "cloudflare_record" "frontend" {
  zone_id = var.zone_id
  name    = "@"
  value   = aws_eip.frontend.public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "backend" {
  zone_id = var.zone_id
  name    = var.backend_subdomain
  value   = aws_eip.backend.public_ip
  type    = "A"
  proxied = true
}
