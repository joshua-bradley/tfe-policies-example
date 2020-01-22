variable "tfe_token" {}

variable "tfe_hostname" {
  description = "The domain where your TFE is hosted."
  default     = "app.terraform.io"
}

variable "tfe_organization" {
  description = "The TFE organization to apply your changes to."
  default     = "Patrick"
}

variable "prod_workspaces" {
  type = "list"

  default = [
    "my_workspace_prod1=_1",
  ]
}

variable "repo_org" {}

variable "oauth_token_id" {}

