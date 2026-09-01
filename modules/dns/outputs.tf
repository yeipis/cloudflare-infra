output "records_summary" {
  description = "Summary map of managed DNS record IDs by category"
  value = {
    a_records     = [for k, r in cloudflare_dns_record.a_records : "${r.name} -> ${r.content} (ID: ${r.id})"]
    aaaa_records  = concat([for k, r in cloudflare_dns_record.aaaa_records : "${r.name} -> ${r.content} (ID: ${r.id})"], ["${cloudflare_dns_record.api.name} -> ${cloudflare_dns_record.api.content} (ID: ${cloudflare_dns_record.api.id})"])
    cname_records = [for k, r in cloudflare_dns_record.cnames : "${r.name} -> ${r.content} (ID: ${r.id})"]
    mx_records    = [for k, r in cloudflare_dns_record.mx_records : "Priority ${r.priority}: ${r.content} (ID: ${r.id})"]
    txt_records   = [for k, r in cloudflare_dns_record.txt_records : "${r.name} (ID: ${r.id})"]
  }
}

output "a_record_ids" {
  description = "IDs of the A records"
  value       = [for r in cloudflare_dns_record.a_records : r.id]
}

output "aaaa_record_ids" {
  description = "IDs of the AAAA records"
  value       = concat([for r in cloudflare_dns_record.aaaa_records : r.id], [cloudflare_dns_record.api.id])
}

output "api_record_id" {
  description = "ID of the api.yeipi.dev API Gateway record"
  value       = cloudflare_dns_record.api.id
}

output "cname_record_ids" {
  description = "IDs of the CNAME records"
  value       = [for r in cloudflare_dns_record.cnames : r.id]
}

output "mx_record_ids" {
  description = "IDs of the MX records"
  value       = [for r in cloudflare_dns_record.mx_records : r.id]
}

output "txt_record_ids" {
  description = "IDs of the TXT records"
  value       = [for r in cloudflare_dns_record.txt_records : r.id]
}
