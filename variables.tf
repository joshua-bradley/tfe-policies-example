variable "tfe_token" {}

variable "tfe_hostname" {
  description = "The domain where your TFE is hosted."
  default     = "app.terraform.io"
}

variable "tfe_organization" {
  description = "The TFE organization to apply your changes to."
}

#variable "prod_workspaces" {
#  type = "list"#
#
#  default = [
#    "my_workspace_prod1=_1",
#  ]
#}

variable "repo_org" {}

variable "oauth_token_id" {}

variable "policies_global" {
  description = "Enable/Disable Global Policies"
  default     = 1
}
variable "policies_team" {
  description = "Enable/Disable Team Policies"
  default     = 1
}
variable "policies_teams" {
  description = "Enable/Disable Teams Policies"
  default     = 0
}
variable "policies_org" {
  description = "Enable/Disable Org Policies"
  default     = 0
}