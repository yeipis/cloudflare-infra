output "configured_forwardings" {
  description = "Map of configured email forwardings and their rule IDs"
  value = {
    destination = var.destination_email
    forwardings = [for addr, rule in cloudflare_email_routing_rule.forwardings : "${addr} -> ${var.destination_email} (ID: ${rule.id})"]
  }
}

output "rule_ids" {
  description = "List of Email Routing rule IDs"
  value       = [for rule in cloudflare_email_routing_rule.forwardings : rule.id]
}
