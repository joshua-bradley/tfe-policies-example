terraform {
  backend "remote" {
    hostname = "${var.tfe_hostname}"

    #organization = "hashicorp-v2"
    organization = "${var.tfe_organization}"

    workspaces {
      name = "tfe-policies-example"
    }
  }
}

provider "tfe" {
  hostname = "${var.tfe_hostname}"
  token    = "${var.tfe_token}"
  version  = "~> 0.6"
}

data "tfe_workspace_ids" "all" {
  names        = ["*"]
  organization = "${var.tfe_organization}"
}

locals {
  workspaces = "${data.tfe_workspace_ids.all.external_ids}" # map of names to IDs
}