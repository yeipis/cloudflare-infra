output "configured_forwardings" {
  description = "Map of configured email forwardings and their rule IDs"
  value = {
    destination = var.destination_email
    forwardings = [for addr, rule in cloudflare_email_routing_rule.forwardings : "${addr} -> ${var.destination_email} (ID: ${rule.id})"]
    catch_all   = "All unmatched emails -> email-catch-all-reject worker (ID: ${cloudflare_email_routing_catch_all.catch_all_reject.id})"
  }
}

output "rule_ids" {
  description = "List of Email Routing rule IDs"
  value       = [for rule in cloudflare_email_routing_rule.forwardings : rule.id]
}

output "catch_all_id" {
  description = "The ID of the catch-all email routing rule"
  value       = cloudflare_email_routing_catch_all.catch_all_reject.id
}
