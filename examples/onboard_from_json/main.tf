provider azurerm {
  features {}
}

locals {
  // return the list of json files in the files directory.
  group_files = fileset(path.module, "./files/*.json")

  // write out the contents of all of the files in the group_files local variable.
  inputs =  [ for v in local.group_files : file(v)  ]
}


module "workspace_onboarding" {
  source = "../.."

  // set the "key" for the loop to be the app_id value. jsondecode is used to convert the json string.
  for_each = { for v in local.inputs: jsondecode(v).app_id => v }

  app_id = jsondecode(each.value)["app_id"]

  // Permissions
  permissions = jsondecode(each.value)["permissions"]
  #workspace_admins    = jsondecode(each.value)["permissions"]["admin"]["members"]
  #workspace_plan      = jsondecode(each.value)["permissions"]["plan"]["members"]
  #workspace_read_only = jsondecode(each.value)["permissions"]["read_only"]["members"]

  tfe_org_name = "grantorchard"

  create_azure_account = false
}

resource "azuread_application" "example" {
  name                       = "example"
  homepage                   = "https://homepage"
  identifier_uris            = ["https://uri"]
  reply_urls                 = ["https://replyurl"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
  type                       = "webapp/api"
  owners                     = ["00000004-0000-0000-c000-000000000000"]

  dynamic app_role {
    for_each = toset(flatten([ for v in module.workspace_onboarding: v.groups ]))
    content {
      allowed_member_types = [
        "User",
      ]

      description  = app_role.value.description
      display_name = app_role.value.name
      is_enabled   = true
      value        = app_role.value.name
    }
  }
}



/*
Create a Terraform workspace - Linked to the above Bitbucket Repo
Create a Terraform team (for the required permission)
Assign the Terraform team to the Terraform workspace
Create an AAD Application Role with value matching the Terraform team name
Create an AAD group with required members 
Assign the AAD group the AAD Application Role
User logs in to Terraform and the SAML assertion puts the user into the Terraform team, which grants the user the requisite permissions to the Terraform workspace. 10. 
Vra fires the automated host onboarding job (OpenLDAP API written by Ian Lochrin + team for RHEL) for the user onboarding to the rhel machines. 


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