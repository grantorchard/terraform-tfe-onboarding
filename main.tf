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


data vault_generic_secret "this" {
  path = vault_azure_secret_backend_role.this.id
}