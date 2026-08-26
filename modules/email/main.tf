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
# NOTE ON CATCH-ALL EMAIL ROUTING:
# ==============================================================================
# A Catch-All rule routing unmatched emails to the Cloudflare Worker 
# `email-catch-all-reject` is managed in conjunction with the `cloudflare-workers`
# repository. Once the worker is deployed, a catch-all rule can be provisioned as:
#
# resource "cloudflare_email_routing_catch_all" "catch_all_reject" {
#   zone_id = var.zone_id
#   name    = "Catch-all to worker reject"
#   enabled = true
#
#   matchers = [
#     {
#       type = "all"
#     }
#   ]
#
#   actions = [
#     {
#       type  = "worker"
#       value = ["email-catch-all-reject"]
#     }
#   ]
# }
# ==============================================================================
