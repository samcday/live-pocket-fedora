variable "account_id" {
  type        = string
  description = "Cloudflare account ID."
  default     = "444c14b123bd021dcdf0400fbd847d63"
}

variable "r2_bucket_name" {
  type        = string
  description = "Existing R2 bucket used by bleeding.fastboop.win."
  default     = "fastboop-bleeding"
}

variable "r2_bucket_item_write_permission_group_id" {
  type        = string
  description = "Cloudflare permission group ID for Workers R2 Storage Bucket Item Write."
  default     = "6a018a9f2fc74eb6b293b0c548f38b39"
}

variable "github_owner" {
  type        = string
  description = "GitHub repository owner."
  default     = "samcday"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name."
  default     = "live-pocket-fedora"
}

variable "state_passphrase" {
  type        = string
  description = "Passphrase for OpenTofu state encryption (min 16 chars)."
  sensitive   = true
}
