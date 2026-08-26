# ==============================================================================
# Cloudflare Zone Settings (SSL/TLS, Security, Optimization)
# ==============================================================================
locals {
  settings = {
    "ssl"               = var.ssl
    "always_use_https"  = var.always_use_https
    "min_tls_version"   = var.min_tls_version
    "http3"             = var.http3
    "brotli"            = var.brotli
  }
}

resource "cloudflare_zone_setting" "settings" {
  for_each = local.settings

  zone_id    = var.zone_id
  setting_id = each.key
  value      = each.value
}
