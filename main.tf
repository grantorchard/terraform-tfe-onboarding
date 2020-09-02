//Create the AD groups for admin and readonly users.
data azuread_users "users" {
  for_each = var.permissions
  mail_nicknames = each.value.members
}

resource azuread_group "users" {
  for_each = var.permissions
  name = each.key
  description = each.value.description
  members = data.azuread_users.users[each.key].object_ids
}

data azuread_users "owners" {
  for_each = var.permissions
  mail_nicknames = each.value.members
}

resource azuread_group "owners" {
  for_each = var.permissions
  name = each.key
  members = data.azuread_users.owners[each.key].object_ids
}

// Create the TFE workspace
resource tfe_workspace "this" {
  name = var.app_id
  organization = var.tfe_org_name
}

// Create the TFE teams from AD object ids. We need this because we can't assign the group names to approles on the Azure AD App.
resource tfe_team "this" {
  for_each = var.permissions
  name         = azuread_group.users[each.key].object_id
  organization = var.tfe_org_name
}

// Create permissions structure for TFE teams
resource tfe_team_access "this" {
  for_each = var.permissions
  team_id      = tfe_team.this[each.key].id
  workspace_id = tfe_workspace.this.id
  access       = each.key == "outputs_only" ? null : each.key
  dynamic permissions {
    for_each = each.key == "outputs_only" ? [0] : []
    content {
      runs = "read"
      variables = "none"
      state_versions = "read-outputs"
      sentinel_mocks = "none"
      workspace_locking = "false"
    }
  }
}
/*
resource tfe_team_access "read_only" {
  team_id      = tfe_team.read_only.id
  workspace_id = tfe_workspace.this.id
  permissions {
    runs = "read"
    variables = "none"
    state_versions = "read-outputs"
    sentinel_mocks = "none"
    workspace_locking = "false"
  }
}

// Create TFE environment variables for the Azure Service Principal
resource tfe_variable "arm_client_id" {
  for_each = var.create_azure_account == true ? toset([var.app_id]) : toset([])
  key          = "ARM_CLIENT_ID"
  value        = data.vault_azure_access_credentials.this[var.app_id].client_id
  category     = "env"
  workspace_id = tfe_workspace.this.id
  description  = "Azure service principal details"
}

resource tfe_variable "arm_client_secret" {
  for_each = var.create_azure_account == true ? toset([var.app_id]) : toset([])
  key          = "ARM_CLIENT_SECRET"
  value        = data.vault_azure_access_credentials.this[var.app_id].client_secret
  category     = "env"
  workspace_id = tfe_workspace.this.id
  description  = "Azure service principal details"
  sensitive = true
}

resource tfe_variable "arm_subscription_id" {
  for_each = var.create_azure_account == true ? toset([var.app_id]) : toset([])
  key          = "ARM_SUBSCRIPTION_ID"
  value        = data.azurerm_client_config.this[var.app_id].subscription_id
  category     = "env"
  workspace_id = tfe_workspace.this.id
  description  = "Azure service principal details"
  sensitive = true
}

resource tfe_variable "arm_tenant_id" {
  for_each = var.create_azure_account == true ? toset([var.app_id]) : toset([])
  key          = "ARM_TENANT_ID"
  value        = data.azurerm_client_config.this[var.app_id].tenant_id
  category     = "env"
  workspace_id = tfe_workspace.this.id
  description  = "Azure service principal details"
  sensitive = true
}
*/