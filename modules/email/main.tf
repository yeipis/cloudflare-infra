# ==============================================================================
# Cloudflare Email Routing - Forwarding Rules
# ==============================================================================
# Forwards emails sent to aliases under yeipi.dev to the destination mailbox.
# ==============================================================================

resource "cloudflare_email_routing_rule" "forwardings" {
  for_each = toset(var.forwarded_addresses)

  zone_id = var.zone_id
  name    = "Forward ${each.value} to destination"
  enabled = true

  matchers = [
    {
      type  = "literal"
      field = "to"
      value = each.value
    }
  ]

  actions = [
    {
      type  = "forward"
      value = [var.destination_email]
    }
  ]
}

# ==============================================================================
# Cloudflare Email Routing - Catch-All Rule to Worker
# ==============================================================================
# Routes all unmapped inbound emails to the `email-catch-all-reject` worker.
# ==============================================================================
resource "cloudflare_email_routing_catch_all" "catch_all_reject" {
  zone_id = var.zone_id
  name    = "Catch-all to email-catch-all-reject worker"
  enabled = true

  matchers = [
    {
      type = "all"
    }
  ]

  actions = [
    {
      type  = "worker"
      value = ["email-catch-all-reject"]
    }
  ]
}
