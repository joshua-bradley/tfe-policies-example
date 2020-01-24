resource "tfe_policy_set" "global" {
  count                  = "${var.policies_global ? 1 : 0}"
  name                   = "global"
  description            = "Global Policies"
  organization           = "${var.tfe_organization}"
  policies_path          = "policies/global"
  global                 = true

  vcs_repo {
    identifier         = "${var.repo_org}/tfe-policies-example"
    branch             = "master"
    ingress_submodules = false
    oauth_token_id     = "${var.oauth_token_id}"
  }
}