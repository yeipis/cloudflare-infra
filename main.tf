# ==============================================================================
# Root Infrastructure Orchestrator - yeipi.dev Cloudflare Infrastructure
# ==============================================================================

module "dns" {
  source = "./modules/dns"

  zone_id = var.cloudflare_zone_id
  domain  = var.domain
}

module "rulesets" {
  source = "./modules/rulesets"

  zone_id = var.cloudflare_zone_id
  domain  = var.domain
}

module "email" {
  source = "./modules/email"

  zone_id           = var.cloudflare_zone_id
  destination_email = var.destination_email
}

module "zone_settings" {
  source = "./modules/zone-settings"

  zone_id = var.cloudflare_zone_id
}
