variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "ssl" {
  description = "SSL encryption mode (e.g. strict, flexible, full)"
  type        = string
  default     = "strict"
}

variable "always_use_https" {
  description = "Redirect all HTTP requests to HTTPS (on/off)"
  type        = string
  default     = "on"
}

variable "min_tls_version" {
  description = "Minimum TLS version allowed (e.g. 1.0, 1.1, 1.2, 1.3)"
  type        = string
  default     = "1.2"
}

variable "http3" {
  description = "Enable HTTP/3 (with QUIC) (on/off)"
  type        = string
  default     = "on"
}

variable "brotli" {
  description = "Enable Brotli compression (on/off)"
  type        = string
  default     = "on"
}
