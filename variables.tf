variable "cloudflare_api_token" {
  description = "Cloudflare API Token with permissions to edit DNS, Rulesets, Zone Settings and Email Routing"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "The Cloudflare Account ID"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare Zone ID for the target domain"
  type        = string
}

variable "domain" {
  description = "Primary root domain managed by this infrastructure"
  type        = string
  default     = "yeipi.dev"
}

variable "destination_email" {
  description = "Destination email address for Email Routing forwardings"
  type        = string
  default     = "juanpablo.fernandezdelatorre04@gmail.com"
}
