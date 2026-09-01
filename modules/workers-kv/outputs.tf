output "ai_cache_kv_id" {
  description = "ID del KV Namespace para pegar en workers/ai-proxy/wrangler.jsonc"
  value       = cloudflare_workers_kv_namespace.ai_cache.id
}

output "ai_cache_kv_title" {
  description = "Title of the AI Cache KV Namespace"
  value       = cloudflare_workers_kv_namespace.ai_cache.title
}
