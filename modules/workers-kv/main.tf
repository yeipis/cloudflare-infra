# ==============================================================================
# Cloudflare Workers KV Namespace - AI Prompt Cache
# ==============================================================================
resource "cloudflare_workers_kv_namespace" "ai_cache" {
  account_id = var.account_id
  title      = var.kv_title
}
