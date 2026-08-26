# Agents Workspace Guidelines: cloudflare-infra

## 🌐 Project Context
- **Target Domain:** yeipi.dev
- **Provider:** cloudflare/cloudflare (~> 5.0 Plugin Framework)
- **Remote State:** Cloudflare R2 bucket `terraform-state` via S3 backend (`region = "auto"`)
- **Companion Repository:** `cloudflare-workers` (manages serverless application code & catch-all email handler)

## 🔒 Security & Privacy Invariants
- This repository is **PUBLIC**.
- NEVER hardcode secrets, API tokens, account IDs, zone IDs, or personal emails in `.tf` files or commit them.
- All secrets must be passed via `terraform.tfvars` (gitignored), `backend.tfvars` (gitignored), or GitHub Actions Secrets.
- Always provide `.example` templates for new variables.

## 📝 Language & Style Invariants
- All documentation, commit messages (Conventional Commits), variable descriptions, and code comments MUST be in **English**.

## 🏗️ Terraform & Cloudflare v5 Rules
- **Submodule Provider Declarations:** Every child module in `modules/*` must have a `versions.tf` specifying `source = "cloudflare/cloudflare"`.
- **Resource Conventions (Provider v5):**
  - DNS: `cloudflare_dns_record`
  - WAF & Cache: `cloudflare_ruleset`
  - Email Routing: `cloudflare_email_routing_rule`
  - Zone Settings: `cloudflare_zone_setting`
- **Ruleset Import Format:** `zones/<zone_id>/<ruleset_id>`.
- **PowerShell CLI:** Use `terraform init "-backend-config=backend.tfvars"` to prevent parameter parsing issues.
