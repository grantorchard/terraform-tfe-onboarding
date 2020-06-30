#provider tfe {}
#provider github {}
provider vault {}
provider azurerm {
  features {}
}

/***************************************************
1. Functional specs.

Thinking through the flow here, what user inputs are
we going to get, and what are we going to do with
those?

var.sensitivity will be one of (a, b, c) and will dictate the Vault path to be used when creating Accounts

*/

resource azurerm_resource_group "this" {
  name     = "foo"
  location = "australiaeast"
}

resource vault_azure_secret_backend_role "this" {
  backend                     = "azure-prod"
  role                        = "generated_role"

  azure_roles {
    role_name = "Contributor"
    scope =  azurerm_resource_group.this.id
  }
}

data vault_azure_access_credentials "this" {
  role = vault_azure_secret_backend_role.this.name
  validate_creds = true
  num_sequential_successes = 8
  num_seconds_between_tests = 7
}

