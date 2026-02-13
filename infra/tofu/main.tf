provider "cloudflare" {
}

provider "github" {
  owner = var.github_owner
}

locals {
  r2_bucket_resource = "com.cloudflare.edge.r2.bucket.${var.account_id}_default_${var.r2_bucket_name}"
}

resource "cloudflare_api_token" "live_pocket_fedora_upload" {
  name = "live-pocket-fedora-r2-upload"

  lifecycle {
    precondition {
      condition     = length(var.r2_bucket_item_write_permission_group_id) > 0
      error_message = "r2_bucket_item_write_permission_group_id must be non-empty."
    }
  }

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = var.r2_bucket_item_write_permission_group_id
    }]
    resources = jsonencode({
      (local.r2_bucket_resource) = "*"
    })
  }]
}

resource "github_actions_secret" "r2_access_key_id" {
  repository      = var.github_repo
  secret_name     = "R2_ACCESS_KEY_ID"
  plaintext_value = cloudflare_api_token.live_pocket_fedora_upload.id
}

resource "github_actions_secret" "r2_secret_access_key" {
  repository      = var.github_repo
  secret_name     = "R2_SECRET_ACCESS_KEY"
  plaintext_value = sha256(cloudflare_api_token.live_pocket_fedora_upload.value)
}

resource "github_actions_secret" "r2_bucket" {
  repository      = var.github_repo
  secret_name     = "R2_BUCKET"
  plaintext_value = var.r2_bucket_name
}

resource "github_actions_secret" "r2_endpoint_url" {
  repository      = var.github_repo
  secret_name     = "R2_ENDPOINT_URL"
  plaintext_value = "https://${var.account_id}.r2.cloudflarestorage.com"
}

resource "github_actions_secret" "tofu_state_passphrase" {
  repository      = var.github_repo
  secret_name     = "TF_VAR_state_passphrase"
  plaintext_value = var.state_passphrase
}
