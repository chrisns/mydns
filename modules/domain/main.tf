variable "domain" {
  description = "domain name"
}

variable "redirect_nowww" {
  description = "redirect non www to www."
  default = false
}

variable "s3" {
  description = "host www on s3"
  default = false
}

resource "cloudflare_zone" "zone" {
  zone = var.domain
  plan = "free"
}

resource "cloudflare_record" "www" {
  count = var.s3 ? 1 : 0
  zone_id = cloudflare_zone.zone.id
  name    = "www"
  value   = "www.${var.domain}.s3-website.eu-west-2.amazonaws.com"
  type    = "CNAME"
  ttl     = 3600
}

resource "cloudflare_record" "A" {
  count = var.redirect_nowww ? 1 : 0
  zone_id = cloudflare_zone.zone.id
  name    = "@"
  value   = "45.55.72.95"
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "txt" {
  count = var.redirect_nowww ? 1 : 0
  zone_id = cloudflare_zone.zone.id
  name    = "_redirect"
  value   = "Redirects from /* to http://www.${var.domain}/*"
  type    = "TXT"
  ttl     = 3600
}

output "zone" {
  value = cloudflare_zone.zone
}