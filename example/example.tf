#provider
terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "subscription" {
  source = "github.com/Azure-Terraform/terraform-azurerm-subscription-data.git?ref=v1.0.0"
  subscription_id = var.subscription_id
}

# us-dns-prod Owner over RISK MG
locals{
  scope = var.workspace_name == "us-dns-prod" ? "/providers/Microsoft.Management/managementGroups/Risk" : "/subscriptions/${var.subscription_id}"
}

resource "vault_azure_secret_backend_role" "subscription_owner" {
  backend                     = var.azure_secret_backend_path
  role                        = "role-terraform-azure-${var.workspace_name}"
  ttl                         = 300
  max_ttl                     = 600
  renewable                   = true

  azure_roles {
    role_name = "Owner"
    scope     = local.scope
  }
  
  azure_roles {
    role_name = "Terraform Enterprise Custom Role"
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


###### Vault token resource test#####

resource "vault_policy" "test" {
  name   = "policy-terraform-azure-test"
  policy = <<EOF
path "secret/*" { capabilities = [ "list" ] }
EOF
}

resource "vault_token" "test" {
  policies  = [vault_policy.test.name]
  renewable = true
  no_default_policy = true
  no_parent = true
  ttl       = "60s"
  explicit_max_ttl = "1h"
  display_name  ="test"
  period   = 0

  renew_min_lease = "10"
  renew_increment = "30"

}