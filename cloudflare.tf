resource "cloudflare_record" "www" {
  domain  = var.domain
  name    = "@"
  value   = aws_eip.frontend.public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "www" {
  domain  = var.domain
  name    = var.backend_subdomain
  value   = aws_eip.frontend.public_ip
  type    = "A"
  proxied = true
}
