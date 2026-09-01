output "domain" {
  description = "The root domain managed by Terraform"
  value       = var.domain
}

output "zone_id" {
  description = "The Cloudflare Zone ID"
  value       = var.cloudflare_zone_id
}

output "dns_records" {
  description = "Summary of configured DNS records"
  value       = module.dns.records_summary
}

output "rulesets" {
  description = "Deployed Cloudflare Ruleset IDs (WAF, Rate Limiting, Cache, Security Headers, Dynamic Redirects)"
  value       = module.rulesets.ruleset_ids
}

output "email_forwardings" {
  description = "Configured email routing rules"
  value       = module.email.configured_forwardings
}

output "zone_settings" {
  description = "Configured zone security and performance settings"
  value       = module.zone_settings.applied_settings
}

output "ai_cache_kv_id" {
  description = "ID del KV Namespace para pegar en workers/ai-proxy/wrangler.jsonc"
  value       = module.workers_kv.ai_cache_kv_id
}
