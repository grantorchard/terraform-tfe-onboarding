provider azurerm {
  features {}
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