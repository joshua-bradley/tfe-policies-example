resource "tfe_policy_set" "org" {
  name                   = "org-policies"
  description            = "Organization Policies"
  organization           = "${var.tfe_organization}"
  policies_path          = "policies/org"
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

resource "null_resource" "sentinal_vars" {

  triggers = {
    shell_hash = "${sha256(file("${path.module}/appsettings.sh"))}"
  }
  provisioner "local-exec" {
      command = "${path.module}/scripts/create_policyset_vars.sh"
      interpreter = ["sh"]
      working_dir = "${path.module}"
      environment = {
        ATLAS_TOKEN = "${var.tfe_token}"
      }
  }

  depends_on = ["tfe_policy_set.org"]
}