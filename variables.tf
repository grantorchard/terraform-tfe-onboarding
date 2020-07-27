// General variables
variable tfe_org_name {
  type = string
}

variable app_id {
  description = "The unique ID of the application that the Terraform workspace and related infrastructure is being provisioned for."
  type        = string
}

variable environment {
  description = "The environment name."
  type        = string
  default     = "production"
  validation {
    condition = (
      var.environment == "production" || var.environment == "development"
    )
    error_message = "The environment value must be one of development or production."
  }
}

// Cloud/infrastructure toggles
variable create_aws_account {
  description = "A boolean flag to determine whether AWS constructs should be created."
  type        = bool
  default     = false
}

variable create_azure_account {
  description = "A boolean flag to determine whether Azure constructs should be created."
  type        = bool
  default     = false
}

variable create_gcp_account {
  description = "A boolean flag to determine whether GCP constructs should be created."
  type        = bool
  default     = false
}

variable create_nsx_account {
  description = "A boolean flag to determine whether NSX constructs should be created."
  type        = bool
  default     = false
}

variable create_vsphere_account {
  description = "A boolean flag to determine whether vSphere constructs should be created."
  type        = bool
  default     = false
}


// Vault variables
variable vault_aws_backend {
  description = "The name of the Vault mount for AWS used to create the Access Key and Secret Key for AWS."
  type        = map(string)
  default     = {
    "production"  = "aws-prod"
    "development" = "aws-dev"
  }
}

variable vault_azure_backend {
  description = "The name of the Vault mount for Azure used to create the Service Principal for TFE."
  type        = map(string)
  default     = {
    "production"  = "azure"
    "development" = "azure"
  }
}

variable vault_azure_role {
  description = "The name of the role in Vault that contains the configuration detail for service principal creation in Azure that will be used by TFE for resource creation/deletion."
  type        = string
  default     = "tfe_service_principal"
}

// Terraform group members (created in Azure AD)
variable workspace_admins {
  description = "UPN of the users who will be added to the workspace administration group."
  type    = list
}

variable workspace_read_only {
  description = "UPN of the users who will be added to the workspace readonly group. These users can still trigger Terraform plan and apply through the standard workflow, but not from the UI."
  type    = list
}

// Azure Variables
variable location {
  type = string
  default = "australiaeast"
}