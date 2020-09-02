// If create_azure_account is true...
/*
// Get the current Azure client context to feed into downstream resources.
data azurerm_client_config "this" {
  for_each = var.create_azure_account == true ? toset([var.app_id]) : toset([])
}

// Create the resource group so that we can scope the credentials created by Vault down to a constrained set of resources.
resource azurerm_resource_group "this" {
  for_each = var.create_azure_account == true ? toset([var.app_id]) : toset([])
  name     = var.app_id
  location = var.location
}

// Check the vault_azure_backend variable to use as the Vault path based on the environment. This may be able to be resolved from the app_id.
resource vault_azure_secret_backend_role "this" {
  for_each = var.create_azure_account == true ? toset([var.app_id]) : toset([])
  backend  = lookup(var.vault_azure_backend, var.environment)
  role     = var.vault_azure_role

  azure_roles {
    role_name = "Contributor"
    scope     = azurerm_resource_group.this[var.app_id].id
  }
}

// Validate propogation of the credentials created by Vault.
data vault_azure_access_credentials "this" {
  depends_on                = [vault_azure_secret_backend_role.this]
  for_each                  = var.create_azure_account == true ? toset([var.app_id]) : toset([])
  backend                   = vault_azure_secret_backend_role.this[var.app_id].backend
  role                      = vault_azure_secret_backend_role.this[var.app_id].role
  validate_creds            = true
  num_sequential_successes  = 8
  num_seconds_between_tests = 7
}

// Here ends the Azure related bits.
*/