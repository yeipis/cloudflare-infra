variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "domain" {
  description = "Target domain name"
  type        = string
  default     = "yeipi.dev"
}
