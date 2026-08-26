# 🌐 Cloudflare Infrastructure (`cloudflare-infra`)

Modular, production-grade Infrastructure as Code (IaC) powered by **Terraform / OpenTofu** and the **Cloudflare Provider v5 (`~> 5.0`)** to manage DNS records, perimeter security (Custom WAF Rules, Rate Limiting), edge caching, Email Routing, and global zone settings for **[`yeipi.dev`](https://yeipi.dev)**.

Remote state (`terraform.tfstate`) is securely stored at zero cost using **Cloudflare R2** via its S3-compatible API.

---

## 🏛️ Architecture Overview

```mermaid
flowchart TD
    subgraph Internet ["🌐 Internet Traffic"]
        User["👤 Legitimate Visitors / Browsers"]
        Crawler["🤖 Web Crawlers & Bots"]
        Attacker["⚠️ Malicious Traffic / Exploit Payloads"]
    end

    subgraph CloudflareEdge ["🛡️ Cloudflare Edge Network (yeipi.dev)"]
        ZoneConfig["🔒 Zone Settings\n(SSL Strict, TLS 1.2+, HTTP/3, Brotli)"]
        WAF["🧱 WAF Custom Rulesets\n(5 Block & Managed Challenge Rules)"]
        RateLimit["⏱️ Rate Limiting\n(5 req / 10s -> Block 10s)"]
        Cache["⚡ Cache Rules\n(Images 2h TTL / Ignore Query String)"]
        DNS["📡 DNS Layer (Proxied Anycast)\n(A, AAAA, CNAME, TXT, MX)"]
        EmailRouter["📬 Cloudflare Email Routing"]
    end

    subgraph Origins ["🚀 Origins & Endpoints"]
        GHPages["🐙 GitHub Pages\n(IPv4 / IPv6 Anycast)"]
        WorkersRepo["⚡ cloudflare-workers\n(Catch-all Worker / APIs)"]
        Gmail["✉️ Gmail Destination\n(juanpablo.fernandezdelatorre04@gmail.com)"]
    end

    subgraph StateStorage ["📦 Remote State Storage ($0 Cost)"]
        R2["🪣 Cloudflare R2 Bucket\n(terraform-state / S3 Protocol)"]
    end

    User --> ZoneConfig
    Crawler --> ZoneConfig
    Attacker --> ZoneConfig

    ZoneConfig --> WAF
    WAF -- Clean Traffic --> RateLimit
    WAF -- Threats / Attacks --> Blocked["🚫 Blocked / Challenged"]
    
    RateLimit --> Cache
    Cache -- Cache Hit --> EdgeResponse["⚡ Immediate Cached Response"]
    Cache -- Cache Miss --> DNS

    DNS --> GHPages
    EmailRouter -- Configured Aliases --> Gmail
    EmailRouter -. Catch-all .-> WorkersRepo

    TerraformCLI["🛠️ Terraform / GitHub Actions"] -->|State Read & Write| R2
    TerraformCLI -->|Provision Resources| CloudflareEdge
```

### 🔗 Relationship with `cloudflare-workers`

This repository (`cloudflare-infra`) provisions and manages the foundational **DNS and Edge Infrastructure**. It coordinates with the companion repository **[`cloudflare-workers`](https://github.com/yeipis/cloudflare-workers)**:
* **Infrastructure Layer (`cloudflare-infra`):** Declares DNS records, WAF security expressions, rate limiters, cache optimization rules, and direct email forwardings.
* **Application / Serverless Layer (`cloudflare-workers`):** Implements backend APIs and the serverless email handler (`email-catch-all-reject`), which acts as the target for unmapped domain emails.

---

## 📁 Repository Structure

```text
cloudflare-infra/
├── .github/
│   └── workflows/
│       ├── terraform-check.yml       # PR validation: formatting, linting & plan
│       └── terraform-deploy.yml      # Main deployment: automatic apply on merge
├── modules/
│   ├── dns/                          # DNS records (A, AAAA, CNAME, MX, TXT)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── rulesets/                     # WAF Custom, Rate Limiting & Cache Rules
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── email/                        # Email Routing forwarding rules
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── zone-settings/                # SSL Strict, TLS 1.2+, HTTP/3, Brotli
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── .gitignore                        # Secret & state file leak prevention
├── LICENSE                           # MIT License
├── README.md                         # Project documentation and quickstart
├── backend.tf                        # S3-compatible backend targeting Cloudflare R2
├── backend.tfvars.example            # Template for local R2 backend credentials
├── main.tf                           # Root orchestrator invoking all submodules
├── variables.tf                      # Global variable declarations
├── outputs.tf                        # Summary outputs and resource IDs
├── terraform.tfvars.example          # Template for local Terraform variables
└── versions.tf                       # Terraform >= 1.5.0 and Cloudflare ~> 5.0
```

---

## 🛡️ Public Repository Security Design

> [!IMPORTANT]
> This repository is fully safe for public hosting. Zero secrets, tokens, or private keys are tracked in version control.

* **Git Ignore Policies:** `.gitignore` protects `*.tfvars`, `*.tfvars.json`, `backend.tfvars`, `*.tfstate`, and `.env*`.
* **Clean Templates:** `terraform.tfvars.example` and `backend.tfvars.example` provide placeholder configurations.
* **Least Privilege:** API tokens require only the specific permissions needed for `yeipi.dev`.

---

## 🪣 Remote State Setup with Cloudflare R2 ($0 Cost)

To configure the zero-cost remote backend on Cloudflare R2:

1. In the **Cloudflare Dashboard**, navigate to **R2 Object Storage**.
2. Create a bucket named **`terraform-state`**.
3. In the R2 sidebar, click **Manage R2 API Tokens** > **Create API Token**:
   * **Permissions:** `Object Read & Write`
   * **Scope:** Apply to bucket `terraform-state`
4. Copy the generated credentials:
   * **Access Key ID**
   * **Secret Access Key**
   * **Endpoint URL:** `https://<CLOUDFLARE_ACCOUNT_ID>.r2.cloudflarestorage.com`

---

## 🚀 Quickstart & Local Usage

### 1. Configure Local Variables

Copy the example templates:

```powershell
# Windows (PowerShell)
Copy-Item terraform.tfvars.example terraform.tfvars
Copy-Item backend.tfvars.example backend.tfvars
```

```bash
# Linux / macOS
cp terraform.tfvars.example terraform.tfvars
cp backend.tfvars.example backend.tfvars
```

Populate `terraform.tfvars`:
```hcl
cloudflare_api_token  = "your_cloudflare_api_token_here"
cloudflare_account_id = "your_cloudflare_account_id_here"
cloudflare_zone_id    = "your_cloudflare_zone_id_here"
domain                = "yeipi.dev"
destination_email     = "juanpablo.fernandezdelatorre04@gmail.com"
```

Populate `backend.tfvars`:
```hcl
endpoint   = "https://<CLOUDFLARE_ACCOUNT_ID>.r2.cloudflarestorage.com"
access_key = "your_r2_access_key_id"
secret_key = "your_r2_secret_access_key"
```

### 2. Initialize and Apply Infrastructure

```bash
# Initialize Terraform and connect to R2 remote backend
terraform init -backend-config=backend.tfvars

# Validate syntax and configuration
terraform validate

# Preview changes
terraform plan

# Apply infrastructure changes
terraform apply
```

---

## 🤖 CI/CD with GitHub Actions

The repository includes two automated workflows in `.github/workflows/`:
1. **`terraform-check.yml` (Pull Requests):** Runs on every PR targeting `main`. Performs `terraform fmt -check`, `terraform validate`, and `terraform plan`.
2. **`terraform-deploy.yml` (Main Branch):** Runs automatically on push to `main`. Executes `terraform apply -auto-approve`.

### Required GitHub Repository Secrets

Configure the following secrets under **Settings** > **Secrets and variables** > **Actions**:

| Secret Name | Description | Source |
| :--- | :--- | :--- |
| `CLOUDFLARE_API_TOKEN` | Cloudflare API Token with Zone, DNS, WAF, Email permissions | Cloudflare Dashboard > API Tokens |
| `CLOUDFLARE_ACCOUNT_ID` | Your Cloudflare Account ID | Cloudflare Dashboard URL / Overview |
| `CLOUDFLARE_ZONE_ID` | Zone ID for `yeipi.dev` | Zone Overview page |
| `AWS_ACCESS_KEY_ID` | Cloudflare R2 Access Key ID | R2 > Manage R2 API Tokens |
| `AWS_SECRET_ACCESS_KEY` | Cloudflare R2 Secret Access Key | R2 > Manage R2 API Tokens |

---

## 📋 Managed Resources Summary

### 1. DNS (`modules/dns/`)
* **A Records (Proxied):** Points apex `yeipi.dev` to GitHub Pages Anycast IPv4 (`185.199.111.153`, `185.199.110.153`, `185.199.109.153`, `185.199.108.153`).
* **AAAA Records (Proxied):** Points apex `yeipi.dev` to GitHub Pages Anycast IPv6 (`2606:50c0:8000::153`, `2606:50c0:8001::153`, `2606:50c0:8002::153`, `2606:50c0:8003::153`).
* **CNAME Records (Proxied):**
  * `greenfleet.yeipi.dev` -> `yeipi.dev`
  * `parkit.yeipi.dev` -> `yeipi.dev`
  * `poketools.yeipi.dev` -> `yeipi.dev`
  * `www.yeipi.dev` -> `yeipis.github.io`
* **MX Records:** Cloudflare Email Routing endpoints (`route1`, `route2`, `route3.mx.cloudflare.net`).
* **TXT Records:** DKIM (`cf2024-1._domainkey`), DMARC (`_dmarc`), GitHub Pages domain verification challenge, and SPF (`v=spf1 ...`).

### 2. Security & Rulesets (`modules/rulesets/`)
* **WAF Custom Rules (`http_request_firewall_custom`):**
  1. `[WAF] Bad Bots & Crawlers` (Blocks malicious user agents, disallowed HTTP methods, malicious ASNs).
  2. `[WAF] Exploiting Fix` (Mitigates SQL injection, XSS vectors, path traversals, PHP/RCE probes).
  3. `[WAF] Block Malicious Traffic & Files` (Blocks automated scanners and probes targeting `.env`, `.git`, `.aws`, admin panels).
  4. `[WAF] Bad ASNs & Method Fix` (Blocks known attack ASNs and anomaly queries).
  5. `[WAF] Thread Check Challenge` (Managed Challenge for legacy/anomalous HTTP clients).
* **Rate Limiting (`http_ratelimit`):**
  * `[Rate Limit] Anti-DDoS & API Protection`: 5 requests per 10 seconds on `/` and `/api/*`, blocks for 10 seconds.
* **Cache Rules (`http_request_cache_settings`):**
  * `[Cache] Optimización de Imágenes (Ignorar Query)`: 2-hour Edge TTL for `.png`, `.jpg`, `.svg`, `.webp`, and `/img/`, ignoring query strings in the cache key.

### 3. Email Routing (`modules/email/`)
* Forwards inbound emails from aliases to `juanpablo.fernandezdelatorre04@gmail.com`:
  * `admin@yeipi.dev`
  * `contacto@yeipi.dev`
  * `contact@yeipi.dev`
  * `jp@yeipi.dev`
  * `juanpablo@yeipi.dev`

### 4. Zone Settings (`modules/zone-settings/`)
* `ssl = "strict"`
* `always_use_https = "on"`
* `min_tls_version = "1.2"`
* `http3 = "on"`
* `brotli = "on"`

---

## 📄 License

Distributed under the MIT License. See [LICENSE](LICENSE) for full details.