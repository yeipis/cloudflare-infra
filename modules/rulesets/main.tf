# ==============================================================================
# Cloudflare Rulesets - Custom WAF Rules (Phase: http_request_firewall_custom)
# ==============================================================================
resource "cloudflare_ruleset" "waf_custom" {
  zone_id     = var.zone_id
  name        = "yeipi.dev - Custom WAF Rules"
  description = "Custom WAF rules for blocking bad bots, exploit attempts, malicious traffic and thread challenges"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules = [
    {
      ref         = "bad_bots_and_crawlers"
      description = "[WAF] Bad Bots & Crawlers"
      action      = "block"
      enabled     = true
      expression  = <<-EOT
(http.request.version in {"HTTP/1.0"} and not cf.client.bot) or (http.user_agent eq "") or (http.user_agent eq " ") or (http.user_agent eq "-") or (http.user_agent eq "'") or (http.user_agent contains "/x/") or (http.user_agent contains "'XOR(") or (http.user_agent contains "ALittle") or (http.user_agent contains "got (") or (http.user_agent contains "quic-go-HTTP") or (http.user_agent contains "Go-http-client") or (http.user_agent contains "fasthttp") or (http.user_agent contains "python") or (http.user_agent contains "java") or (http.user_agent contains "PHP") or (http.user_agent contains "Nmap") or (http.user_agent contains "scrapy" and not cf.client.bot) or (http.user_agent contains "spider" and not cf.client.bot) or (http.user_agent contains "crawl" and not cf.client.bot) or (http.user_agent contains "bot" and not http.user_agent contains "bing" and not http.user_agent contains "google" and not http.user_agent contains "yandex" and not http.user_agent contains "duckduckgo" and not http.user_agent contains "facebook" and not http.user_agent contains "linkedIn" and not http.user_agent contains "twitter" and not http.user_agent contains "yahoo" and not cf.client.bot) or (http.request.method in {"PURGE" "PUT" "OPTIONS" "DELETE" "PATCH"}) or (http.x_forwarded_for contains "192.0.") or (http.x_forwarded_for contains ".0.0") or (ip.geoip.country in {"T1" "XX"} and not http.request.version in {"HTTP/2" "HTTP/3" "SPDY/3.1"} and not cf.client.bot) or (http.user_agent contains "lient" and http.user_agent contains "ttp") or (http.user_agent contains "libweb") or (http.user_agent contains "libwww") or (http.user_agent contains "wrk") or (http.user_agent contains "hey/") or (ip.geoip.asnum in {14061 60631 28438 60592 30823 4134 32505 27715 22773 131090 135905 55330 16629 4755 53363 34549 135330 47285 60798 207590 203087 198651 43289 14576 207319 201978 208425 201094 18978 52000 204601 199883 8220 36351 45011 8560 23969 45629 20207 6471 8075 45899 31400 208556 12271 7552 26496 21769 6876 45102 5617 199490 35816 131293 20860 31898 131428 8881 25429 29802 4788 3326 39284 13448 46484 174 577 29286 5056 9009 63949 212708 40788 12989 11351 11426 7029 42652 18403 54538 209 62044 3269 395003 8100 4190 12874 19740 197540 45458 136258 50837 51852 4826 195 49588 57613 34248 197099 29287 29066 30083 9534 42905 35804 45012 7303 25961 61317 5610 35320 262187 263693 20552 266706 49327 47232 32098 28429 3255 28431 14117 18734 24088 263196 41096 52228 8069 398101 28725 132196 61154 58199 6877 265537 32097 62240 3329 6830 133199 12334 270110 22884 54600 213375 206092 41009 213251 36444} and not http.request.version in {"HTTP/2" "HTTP/3" "SPDY/3.1"} and not cf.client.bot) or (http.host contains ":80") or (http.host contains ":443") or (http.cookie contains "cf_use_ob=" and not http.cookie contains "0" and not http.cookie contains "80" and not http.cookie contains "443" and not cf.client.bot)
EOT
    },
    {
      ref         = "exploiting_fix"
      description = "[WAF] Exploiting Fix"
      action      = "block"
      enabled     = true
      expression  = <<-EOT
(http.request.uri.query contains ")/*") or (http.request.uri.query contains ")-- ") or (http.request.uri.query contains "benchmark(") or (http.request.uri.query contains "'0:0:20'") or (http.request.uri.query contains "MD5(") or (http.request.uri.query contains "%20waitfor%20delay%20") or (http.request.uri.query contains "%22") or (http.request.uri.query contains "%20/*") or (http.request.uri.query contains "%20--") or (http.request.uri.query contains "%20%23") or (http.request.uri.query contains ")%23") or (http.request.uri.query contains "script>") or (http.request.uri.query contains "%40") or (http.request.uri.query contains "%00") or (http.request.uri.query contains "<?php") or (http.request.uri.query contains "0x00") or (http.request.uri.query contains "0x08") or (http.request.uri.query contains "0x09") or (http.request.uri.query contains "0x0a") or (http.request.uri.query contains "0x0d") or (http.request.uri.query contains "0x1a") or (http.request.uri.query contains "0x22") or (http.request.uri.query contains "0x25") or (http.request.uri.query contains "0x27") or (http.request.uri.query contains "0x5c") or (http.request.uri.query contains "0x5f") or (http.request.uri.query contains "SELECT") or (http.request.uri.query contains "concat") or (http.request.uri.query contains "union") or (http.request.uri.query contains "0x50") or (http.request.uri.query contains "DROP") or (http.request.uri.query contains "WHERE") or (http.request.uri.query contains "ONION") or (http.request.uri.query contains "0x3c62723e3c62723e3c62723e") or (http.request.uri.query contains "0x3c696d67207372633d22") or (http.request.uri.query contains "OR") or (http.request.uri.query contains "0x3e") or (http.request.uri.query contains "<img") or (http.request.uri.query contains "<image") or (http.request.uri.query contains "document.cookie") or (http.request.uri.query contains "onerror()") or (http.request.uri.query contains "alert(") or (http.request.uri.query contains "window.") or (http.request.uri.query contains "String.fromCharCode(") or (http.request.uri.query contains "javascript:") or (http.request.uri.query contains "onmouseover=") or (http.request.uri.query contains "<BODY onload") or (http.request.uri.query contains "<style") or (http.request.uri.query contains "svg onload")
EOT
    },
    {
      ref         = "block_malicious_traffic_and_files"
      description = "[WAF] Block Malicious Traffic & Files"
      action      = "block"
      enabled     = true
      expression  = <<-EOT
(http.user_agent contains "HeadlessChrome") or (http.user_agent contains "OPD") or (http.user_agent contains "fasthttp") or (http.user_agent contains "ALittle Client") or (http.user_agent contains "ct‑git‑scanner") or (http.user_agent contains "python-requests") or (http.user_agent contains "curl") or (http.user_agent contains "wget") or (http.user_agent contains "libwww-perl") or (http.user_agent contains "masscan") or (http.user_agent contains "nmap") or (http.user_agent contains "sqlmap") or (http.user_agent contains "nikto") or (http.user_agent contains "ZmEu") or (http.user_agent contains "w3af") or (http.user_agent contains "dirbuster") or (http.user_agent contains "gobuster") or (http.user_agent contains "ffuf") or (http.user_agent contains "wfuzz") or (http.user_agent contains "nuclei") or (http.user_agent contains "httpx") or (http.user_agent contains "subfinder") or (http.user_agent contains "amass") or (http.user_agent contains "zgrab") or (http.user_agent contains "zmap") or (http.user_agent contains "Go-http-client") or (http.user_agent contains "Apache-HttpClient") or (http.user_agent eq "") or (http.request.uri.path contains "/.git") or (http.request.uri.path contains "/.env") or (http.request.uri.path contains "/wp-login") or (http.request.uri.path contains "/wp-admin") or (http.request.uri.path contains "/config.") or (http.request.uri.path contains "/phpinfo") or (http.request.uri.path contains "/shell") or (http.request.uri.path eq "/admin") or (http.request.uri.path eq "/admin/") or (http.request.uri.path contains "/admin.php") or (http.request.uri.path contains "/administrator") or (http.request.uri.path contains "cgi-bin") or (http.request.uri.path contains "/.aws") or (http.request.uri.path contains "/.ssh") or (http.request.uri.path contains "/backup") or (http.request.uri.path contains "/database") or (http.request.uri.path contains "/db_") or (http.request.uri.path contains "/sql") or (http.request.uri.path contains "/phpmyadmin") or (http.request.uri.path contains "/adminer") or (http.request.uri.path contains "/.htaccess") or (http.request.uri.path contains "/.htpasswd") or (http.request.uri.path contains "/web.config") or (http.request.uri.path contains "/composer.json") or (http.request.uri.path contains "/package.json") or (http.request.uri.path contains "/Dockerfile") or (http.request.uri.path contains "/docker-compose") or (http.request.uri.path contains "/.terraform") or (http.request.uri.path contains "/server-status") or (http.request.uri.path contains "/server-info") or (http.request.uri.path contains "/.svn") or (http.request.uri.path contains "/.hg") or (http.request.uri.path contains "/CVS") or (http.request.uri.path contains "/.bzr")
EOT
    },
    {
      ref         = "bad_asns_and_method_fix"
      description = "[WAF] Bad ASNs & Method Fix"
      action      = "block"
      enabled     = true
      expression  = <<-EOT
(ip.geoip.asnum in { 197695 49505 201776 202425 49392 44812 202422 25513 31133 42610 49981 60068 44901 51167 200000 197540 61317 48314 60781 16265 60404 206264 208091 202448 63949 16276 24940 45090 37963 55990 132203 38365 20473 14061 19531 46562 62904 26496 9009 35913 31034 8100 46844 40676 53667 209605 212238 29802 48693 }) or (http.user_agent eq "109e15941c57") or (http.user_agent eq "d1b2df322c91") or (http.request.uri.query eq "--+") or (http.user_agent eq "84bd2cfee733") or (http.request.uri.query eq "d=1") or (http.user_agent eq "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)") or (http.request.uri.query eq "daksldlkdsadas=1")
EOT
    },
    {
      ref         = "thread_check_challenge"
      description = "[WAF] Thread Check Challenge"
      action      = "managed_challenge"
      enabled     = true
      expression  = <<-EOT
(http.request.version in {"HTTP/1.1" "HTTP/1.2"} and not http.request.version in {"HTTP/2" "HTTP/3" "SPDY/3.1"} and not cf.client.bot) or (not ssl and not cf.client.bot) or (http.referer eq "" and not cf.client.bot)
EOT
    }
  ]
}

# ==============================================================================
# Cloudflare Rulesets - Rate Limiting (Phase: http_ratelimit)
# ==============================================================================
resource "cloudflare_ruleset" "rate_limiting" {
  zone_id     = var.zone_id
  name        = "yeipi.dev - Rate Limiting Rules"
  description = "Anti-DDoS and API Protection Rate Limiting Rules"
  kind        = "zone"
  phase       = "http_ratelimit"

  rules = [
    {
      ref         = "anti_ddos_api_protection"
      description = "[Rate Limit] Anti-DDoS & API Protection"
      action      = "block"
      enabled     = true
      expression  = "(http.request.uri.path eq \"/\") or (starts_with(http.request.uri.path, \"/api/\"))"
      ratelimit = {
        characteristics     = ["cf.colo.id", "ip.src"]
        period              = 10
        requests_per_period = 5
        mitigation_timeout  = 10
      }
    }
  ]
}

# ==============================================================================
# Cloudflare Rulesets - Cache Rules (Phase: http_request_cache_settings)
# ==============================================================================
resource "cloudflare_ruleset" "cache_settings" {
  zone_id     = var.zone_id
  name        = "yeipi.dev - Cache Rules"
  description = "Cache optimization rules for images and static assets"
  kind        = "zone"
  phase       = "http_request_cache_settings"

  rules = [
    {
      ref         = "image_cache_optimization"
      description = "[Cache] Optimización de Imágenes (Ignorar Query)"
      action      = "set_cache_settings"
      enabled     = true
      expression  = "(http.request.uri.path wildcard \"*.png\") or (http.request.uri.path wildcard \"*.jpg\") or (http.request.uri.path wildcard \"*.svg\") or (http.request.uri.path wildcard \"*.webp\") or (http.request.uri.path contains \"/img/\")"
      action_parameters = {
        cache = true
        edge_ttl = {
          mode    = "override_origin"
          default = 7200
        }
        cache_key = {
          ignore_query_strings_order = true
          custom_key = {
            query_string = {
              exclude = {
                all = true
              }
            }
          }
        }
      }
    }
  ]
}

# ==============================================================================
# Cloudflare Rulesets - Security Headers (Phase: http_response_headers_transform)
# ==============================================================================
resource "cloudflare_ruleset" "security_headers" {
  zone_id     = var.zone_id
  name        = "${var.domain} - Security Headers"
  description = "Enforce HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, and Permissions-Policy for A+ Rating"
  kind        = "zone"
  phase       = "http_response_headers_transform"

  rules = [
    {
      ref         = "apply_security_headers"
      description = "[Security Headers] Enforce HSTS, Frame Protection, MIME nosniff, and Permissions Policy"
      action      = "rewrite"
      enabled     = true
      expression  = "true"
      action_parameters = {
        headers = {
          "Strict-Transport-Security" = {
            operation = "set"
            value     = "max-age=31536000; includeSubDomains; preload"
          }
          "X-Frame-Options" = {
            operation = "set"
            value     = "DENY"
          }
          "X-Content-Type-Options" = {
            operation = "set"
            value     = "nosniff"
          }
          "Referrer-Policy" = {
            operation = "set"
            value     = "strict-origin-when-cross-origin"
          }
          "Permissions-Policy" = {
            operation = "set"
            value     = "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()"
          }
          "Content-Security-Policy" = {
            operation = "set"
            value     = "upgrade-insecure-requests"
          }
        }
      }
    }
  ]
}

# ==============================================================================
# Cloudflare Rulesets - Dynamic Redirects (Phase: http_request_dynamic_redirect)
# ==============================================================================
resource "cloudflare_ruleset" "dynamic_redirects" {
  zone_id     = var.zone_id
  name        = "${var.domain} - Dynamic Redirects"
  description = "Portfolio shortlinks and social profile redirects"
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"

  rules = [
    {
      ref         = "redirect_github"
      description = "[Redirect] /github & /gh to GitHub Profile"
      action      = "redirect"
      enabled     = true
      expression  = "(http.request.uri.path eq \"/github\") or (http.request.uri.path eq \"/gh\")"
      action_parameters = {
        from_value = {
          status_code           = 301
          preserve_query_string = false
          target_url = {
            value = var.github_url
          }
        }
      }
    },
    {
      ref         = "redirect_linkedin"
      description = "[Redirect] /linkedin & /in to LinkedIn Profile"
      action      = "redirect"
      enabled     = true
      expression  = "(http.request.uri.path eq \"/linkedin\") or (http.request.uri.path eq \"/in\")"
      action_parameters = {
        from_value = {
          status_code           = 301
          preserve_query_string = false
          target_url = {
            value = var.linkedin_url
          }
        }
      }
    },
    {
      ref         = "redirect_cv"
      description = "[Redirect] /cv & /curriculum to Resume/CV"
      action      = "redirect"
      enabled     = true
      expression  = "(http.request.uri.path eq \"/cv\") or (http.request.uri.path eq \"/curriculum\")"
      action_parameters = {
        from_value = {
          status_code           = 302
          preserve_query_string = false
          target_url = {
            value = var.cv_url
          }
        }
      }
    },
    {
      ref         = "redirect_contact"
      description = "[Redirect] /contact, /mail & /email to Mailto"
      action      = "redirect"
      enabled     = true
      expression  = "(http.request.uri.path eq \"/contact\") or (http.request.uri.path eq \"/mail\") or (http.request.uri.path eq \"/email\")"
      action_parameters = {
        from_value = {
          status_code           = 302
          preserve_query_string = false
          target_url = {
            value = "mailto:${var.contact_email}"
          }
        }
      }
    }
  ]
}
