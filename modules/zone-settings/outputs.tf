output "applied_settings" {
  description = "Map of applied zone settings"
  value = {
    for k, v in cloudflare_zone_setting.settings : k => v.value
  }
}

output "setting_ids" {
  description = "Map of zone setting resource IDs"
  value = {
    for k, v in cloudflare_zone_setting.settings : k => v.id
  }
}
