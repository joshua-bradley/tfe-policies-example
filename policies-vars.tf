resource "null_resource" "sentinal_var" {
  count = "${tfe_policy_set.org.id ? 1 : 0}

  triggers = {
    always_run = "${timestamp()}"
  }
  
  provisioner "local-exec" {
      command = "${path.module}/scripts/create_policyset_vars.sh"
      interpreter = ["bash"]
      working_dir = "${path.module}/scripts"
      environment = {
        ATLAS_TOKEN = "${var.tfe_token}"
      }
  }

  depends_on = ["tfe_policy_set.org"]
}