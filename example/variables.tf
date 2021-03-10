variable "azure_secret_backend_path" {
  description = "vault backend path for azure secrets"
  type        = string
  default     = ""
}

variable "workspace_name" {
  description = "workspace name (used in vault API url)"
  type        = string
  default     = "us-infrastructure-dev"
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = ""
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = ""
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

variable "token_explicit_max_ttl" {
  description = "The explicit max TTL of this token"
  default     = "115200"
}