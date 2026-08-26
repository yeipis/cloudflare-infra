variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "destination_email" {
  description = "Destination email address for email routing forwardings"
  type        = string
  default     = "juanpablo.fernandezdelatorre04@gmail.com"
}

variable "forwarded_addresses" {
  description = "List of domain email addresses to forward to destination_email"
  type        = list(string)
  default = [
    "admin@yeipi.dev",
    "contacto@yeipi.dev",
    "contact@yeipi.dev",
    "jp@yeipi.dev",
    "juanpablo@yeipi.dev"
  ]
}
