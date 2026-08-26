terraform {
  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "cloudflare-infra/terraform.tfstate"
    region                      = "auto"
    endpoint                    = "https://<CLOUDFLARE_ACCOUNT_ID>.r2.cloudflarestorage.com"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
