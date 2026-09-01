output "ruleset_ids" {
  description = "Map of created ruleset IDs"
  value = {
    waf_custom        = cloudflare_ruleset.waf_custom.id
    rate_limiting     = cloudflare_ruleset.rate_limiting.id
    cache_rules       = cloudflare_ruleset.cache_settings.id
    security_headers  = cloudflare_ruleset.security_headers.id
    dynamic_redirects = cloudflare_ruleset.dynamic_redirects.id
  }
}

output "waf_custom_id" {
  description = "The ID of the custom WAF ruleset"
  value       = cloudflare_ruleset.waf_custom.id
}

output "rate_limiting_id" {
  description = "The ID of the rate limiting ruleset"
  value       = cloudflare_ruleset.rate_limiting.id
}

output "cache_settings_id" {
  description = "The ID of the cache settings ruleset"
  value       = cloudflare_ruleset.cache_settings.id
}

output "security_headers_id" {
  description = "The ID of the security headers transform ruleset"
  value       = cloudflare_ruleset.security_headers.id
}

output "dynamic_redirects_id" {
  description = "The ID of the dynamic redirects ruleset"
  value       = cloudflare_ruleset.dynamic_redirects.id
}
