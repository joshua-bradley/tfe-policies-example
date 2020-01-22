resource "tfe_policy_set" "platform" {
  name                   = "global_policies"
  description            = "Global Policies"
  organization           = "${var.tfe_organization}"
  policies_path          = "policies/global-policies"
  global                 = true

  vcs_repo {
    identifier         = "${var.repo_org}/tfe-policies-example"
    branch             = "master"
    ingress_submodules = false
    oauth_token_id     = "${var.oauth_token_id}"
  }
}