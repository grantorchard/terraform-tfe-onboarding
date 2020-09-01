provider azurerm {
  features {}
}

locals {
  group_files = fileset(path.module, "../files/*")
  inputs = [ for v in local.group_files : file(v) ]
}

module "workspace_onboarding" {
  source = "../"
  for_each = toset(local.inputs)

  app_id = jsondecode(each.value)["app_id"]

  // Permissions
  workspace_admins = jsondecode(each.value)["permissions"]["admin"]["members"]
  workspace_plan = jsondecode(each.value)["permissions"]["plan"]["members"]
  workspace_read_only = jsondecode(each.value)["permissions"]["read_only"]["members"]

  tfe_org_name = "grantorchard"

  create_azure_account = false
}

/*
Create a Terraform workspace - Linked to the above Bitbucket Repo
Create a Terraform team (for the required permission)
Assign the Terraform team to the Terraform workspace
Create an AAD Application Role with value matching the Terraform team name
Create an AAD group with required members
Assign the AAD group the AAD Application Role


module "workspace_onboarding" {
  source = "blah"

  workspace_name = var.workspace_name
  
  repository_name = "${var.app_id}-${var.app_scope}-${var.environment}-${var.purpose}"


  app_id respository_name respository_branch scope environment purpose
}

module "onboarding-app123abc" {
  source = "../"

  app_id = "123abc" //used for workspace name and AD group creation
  environment = "production" //can we intuit this from the app_id?

  create_azure_account = true

  workspace_admins = [
    "go_hashicorp.com#EXT#"
  ]

  workspace_read_only = [
    "burkey_hashicorp.com#EXT#",
    "cody_hashicorp.com#EXT#"
  ]

  tfe_org_name = "grantorchard"
}

*/