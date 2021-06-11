variable "azure_secret_backend_path" {
  description = "vault backend path for azure secrets"
  type        = string
}

variable "workspace_name" {
  description = "workspace name (used in vault API url)"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "ttl" {
  description = "The default TTL for service principals generated using this role."
  type        = number
  default     = 7200
}

variable "max_ttl" {
  description = "The maximum TTL for service principals generated using this role."
  type        = number
  default     = 43200
}

variable "vault_token_period" {
  description = "Period for generated vault token"
  type        = string
  default     = "768h"
}

variable "vault_token_ttl" {
  description = "TTL for generated vault token"
  type        = string
  default     = "768h"
}

variable "vault_address" {
  description = "Address of Hashicorp Vault"
  type        = string
}

variable "azuread_group_name" {
  description = "Azure Active Directory Group Name"
  type        = string
}

variable "root_management_group" {
  description = "Root management group to allow network peering"
  type        = string
  default     = "RISK"
}

variable "image_gallery_subscription_id" {
  description = "Azure Shared Image Gallery Subscription ID"
  type        = string
  default     = "ed5e2254-5d87-4255-b70e-1b5eba509f73" # us-sharedimages-prod
}

variable "storage_blob_subscription_id" {
  description = "Azure terraform prod subscription ID to allow access to storage containers and blobs"
  type        = string
  default     = "debc4966-2669-4fa7-9bd9-c4cdb08aed9f" # us-terraform-prod
}