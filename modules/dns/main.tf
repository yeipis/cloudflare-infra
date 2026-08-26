# ==============================================================================
# A Records (Root Apex -> GitHub Pages IPv4) - Proxied
# ==============================================================================
locals {
  github_pages_ipv4 = [
    "185.199.111.153",
    "185.199.110.153",
    "185.199.109.153",
    "185.199.108.153"
  ]

  github_pages_ipv6 = [
    "2606:50c0:8000::153",
    "2606:50c0:8001::153",
    "2606:50c0:8002::153",
    "2606:50c0:8003::153"
  ]

  cname_records = {
    "greenfleet" = var.domain
    "parkit"     = var.domain
    "poketools"  = var.domain
    "www"        = "yeipis.github.io"
  }

  mx_records = {
    "route2.mx.cloudflare.net" = 1
    "route1.mx.cloudflare.net" = 27
    "route3.mx.cloudflare.net" = 36
  }

  txt_records = {
    "cf2024-1._domainkey" = "v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78km4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB"
    "_dmarc"              = "v=DMARC1; p=none; rua=mailto:c620409ca21543b1ab9c3492d01970ff@dmarc-reports.cloudflare.net"
    "_github-pages-challenge-yeipis" = "e7eea46a2765c69f2b77309ac41e3f"
    "@"                   = "v=spf1 include:_spf.mx.cloudflare.net include:_spf.google.com ~all"
  }
}

resource "cloudflare_dns_record" "a_records" {
  for_each = toset(local.github_pages_ipv4)

  zone_id = var.zone_id
  name    = "@"
  type    = "A"
  content = each.value
  ttl     = 1
  proxied = true
  comment = "Managed by Terraform - GitHub Pages IPv4"
}

# ==============================================================================
# AAAA Records (Root Apex -> GitHub Pages IPv6) - Proxied
# ==============================================================================
resource "cloudflare_dns_record" "aaaa_records" {
  for_each = toset(local.github_pages_ipv6)

  zone_id = var.zone_id
  name    = "@"
  type    = "AAAA"
  content = each.value
  ttl     = 1
  proxied = true
  comment = "Managed by Terraform - GitHub Pages IPv6"
}

# ==============================================================================
# CNAME Records - Proxied
# ==============================================================================
resource "cloudflare_dns_record" "cnames" {
  for_each = local.cname_records

  zone_id = var.zone_id
  name    = each.key
  type    = "CNAME"
  content = each.value
  ttl     = 1
  proxied = true
  comment = "Managed by Terraform - CNAME for ${each.key}.${var.domain}"
}

# ==============================================================================
# MX Records (Cloudflare Email Routing)
# ==============================================================================
resource "cloudflare_dns_record" "mx_records" {
  for_each = local.mx_records

  zone_id  = var.zone_id
  name     = "@"
  type     = "MX"
  content  = each.key
  priority = each.value
  ttl      = 1
  proxied  = false
  comment  = "Managed by Terraform - Cloudflare Email Routing MX"
}

# ==============================================================================
# TXT Records (DKIM, DMARC, SPF, GitHub Pages Verification)
# ==============================================================================
resource "cloudflare_dns_record" "txt_records" {
  for_each = local.txt_records

  zone_id = var.zone_id
  name    = each.key
  type    = "TXT"
  content = each.value
  ttl     = 1
  proxied = false
  comment = "Managed by Terraform - TXT record for ${each.key}"
}
