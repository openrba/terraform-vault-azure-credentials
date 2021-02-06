resource "vault_azure_secret_backend_role" "subscription_owner" {
  backend                     = var.azure_secret_backend_path
  role                        = "role-terraform-azure-${var.workspace_name}"
  ttl                         = 7200
  max_ttl                     = 14400

  azure_roles {
    role_name = "Owner"
    scope     = "/subscriptions/${var.subscription_id}"
  }
  
  azure_roles {
    role_name = "Terraform Enterprise Virtual Network Peering"
    scope     = "/providers/Microsoft.Management/managementGroups/Risk"
  }
  
}

data "vault_policy_document" "subscription_owner" {
  rule {
    path         = "auth/token/create"
    capabilities = ["update"]
    description  = "Allow creation of child tokens"
  }

  rule {
    path         = "auth/token/lookup-self"
    capabilities = ["read"]
    description  = "Allow a token to get information about itself"
  }

  rule {
    path         = "${vault_azure_secret_backend_role.subscription_owner.backend}/config"
    capabilities = ["read"]
    description  = "Read Azure secrets backend config"
  }

  rule {
    path         = "${vault_azure_secret_backend_role.subscription_owner.backend}/creds/${vault_azure_secret_backend_role.subscription_owner.role}"
    capabilities = ["read"]
    description  = "Allow requesting Azure credentials from Vault"
  }
}

resource "vault_policy" "subscription_owner" {
  name   = "policy-terraform-azure-${var.workspace_name}"
  policy = data.vault_policy_document.subscription_owner.hcl
}

resource "vault_token" "subscription_owner" {
  policies  = [vault_policy.subscription_owner.name]
  renewable = true
  period    = var.vault_token_period
  ttl       = var.vault_token_ttl
}
