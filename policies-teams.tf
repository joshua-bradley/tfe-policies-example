resource "tfe_policy_set" "teams" {
  count                  = "${var.policies_teams ? 1 : 0}"
  name                   = "teams"
  description            = "Multiple Teams Policies"
  organization           = "${var.tfe_organization}"
  policies_path          = "policies/teams"
  workspace_external_ids = [
    "${local.workspaces["patspets_dev"]}",
    "${local.workspaces["patspets_stage"]}",
  ]

  vcs_repo {
    identifier         = "${var.repo_org}/tfe-policies-example"
    branch             = "master"
    ingress_submodules = false
    oauth_token_id     = "${var.oauth_token_id}"
  }
}

resource "null_resource" "sentinal_var_teams" {
  count                  = "${var.policies_org ? 1 : 0}"

  triggers = {
    always_run = "${timestamp()}"
  }
  
  provisioner "local-exec" {
      command = "${path.module}/scripts/create_policyset_vars.sh"
      interpreter = ["bash"]
      working_dir = "${path.module}/scripts"
      environment = {
        ATLAS_TOKEN = "${var.tfe_token}"
        HOST = "${var.tfe_hostname}"
        ORGANIZATION = "${var.tfe_organization}"
      }
  }

  depends_on = ["tfe_policy_set.teams"]
}