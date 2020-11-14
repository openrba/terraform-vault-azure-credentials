resource "vault_azure_secret_backend_role" "subscription_owner" {
  backend                     = var.azure_secret_backend_path
  role                        = "role-terraform-azure-modtest-${var.subscription_name}"
  ttl                         = 300
  max_ttl                     = 600

  azure_roles {
    role_name = "Owner"
    scope     = "/subscriptions/${var.subscription_id}"
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
    path         = "${vault_azure_secret_backend_role.subscription_owner.backend}/creds/modtest-${vault_azure_secret_backend_role.subscription_owner.role}"
    capabilities = ["read"]
    description  = "Allow requesting Azure credentials from Vault"
  }
}

resource "vault_policy" "subscription_owner" {
  name   = "policy-terraform-azure-${var.subscription_name}"
  policy = data.vault_policy_document.subscription_owner.hcl
}

resource "vault_token" "subscription_owner" {
  policies  = [vault_policy.subscription_owner.name]
  renewable = true
  ttl       = var.vault_token_ttl
}