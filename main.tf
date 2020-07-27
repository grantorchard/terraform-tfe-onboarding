//Create the AD groups for admin and readonly users.
data azuread_users "workspace_admins" {
  mail_nicknames = var.workspace_admins
}

resource azuread_group "workspace_admins" {
  name = "${var.app_id}-workspace_admins"
  members = data.azuread_users.workspace_admins.object_ids
}

data azuread_users "workspace_read_only" {
  mail_nicknames = var.workspace_read_only
}

resource azuread_group "workspace_read_only" {
  name = "${var.app_id}-workspace_admins"
  members = data.azuread_users.workspace_read_only.object_ids
}

// Create the TFE workspace
resource tfe_workspace "this" {
  name = var.app_id
  organization = var.tfe_org_name
}

// Create the TFE teams from AD object ids. We need this because we can't assign the group names to approles on the Azure AD App.
resource tfe_team "admin" {
  name         = azuread_group.workspace_admins.object_id
  organization = var.tfe_org_name
}

resource tfe_team "read_only" {
  name         = azuread_group.workspace_read_only.object_id
  organization = var.tfe_org_name
}

// Create permissions structure for TFE teams
resource tfe_team_access "admin" {
  team_id      = tfe_team.admin.id
  workspace_id = tfe_workspace.this.id
  access       = "admin"
}

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