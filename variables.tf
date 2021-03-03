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

variable "azuread_group_id" {
  description = "Azure Active Directory Group ID"
  type        = string
}