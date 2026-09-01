variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "kv_title" {
  description = "Title / name of the KV Namespace"
  type        = string
  default     = "AI_CACHE"
}
