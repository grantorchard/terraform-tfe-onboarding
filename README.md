This module is being developed to address on-boarding requirements as new projects come onto Terraform Enterprise.

# Functional Specs

1. Users will provide a set of inputs that can be used to determine the shape of the resulting workspace. This will include, but not be limited to:
* Dynamic credentials from Vault for Azure (MVP)
* Project classification, which will determine the appropriate subscription and tenant values to use.
* Creation of a Terraform Workspace, including assignment of Azure credentials as environment variables, group allocation, and Sentinel policies.
* Creation of a repo, and depending on provider capability a dynamic rendering of sample modules that the consumer may want to investigate.
* Creation of a Vault token that will be used for interaction with secrets for that workspace.
  - This raises a question regarding secrets management at a workspace/project level, and whether they are placed in a path that we can create a policy for.... TBC.
