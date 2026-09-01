variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "domain" {
  description = "Target domain name"
  type        = string
  default     = "yeipi.dev"
}

variable "linkedin_url" {
  description = "LinkedIn profile URL for shortlink redirects"
  type        = string
  default     = "https://www.linkedin.com/in/jpfdlt/"
}

variable "github_url" {
  description = "GitHub profile URL for shortlink redirects"
  type        = string
  default     = "https://github.com/yeipis"
}

variable "cv_url" {
  description = "CV / Curriculum Vitae URL for shortlink redirects"
  type        = string
  default     = "https://github.com/yeipis"
}

variable "contact_email" {
  description = "Public contact email address for mailto redirects"
  type        = string
  default     = "juanpablo@yeipi.dev"
}
