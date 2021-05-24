output "connection_info" {
  description = "Map of connection info for credential generation"
  sensitive   = true
  value = { subscription_id = var.subscription_id
    tenant_id     = var.tenant_id
    vault_address = var.vault_address
    vault_backend = vault_azure_secret_backend_role.subscription_owner.backend
    vault_role    = vault_azure_secret_backend_role.subscription_owner.role
  vault_token = vault_token.subscription_owner.client_token }
}
