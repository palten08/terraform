terraform {
  source = "${get_parent_terragrunt_dir()}//manifest"

  extra_arguments "disable_input" {
    commands  = get_terraform_commands_that_need_input()
    arguments = ["-input=false"]
  }
}

# Load YAML configuration files
include {
  path = "yaml.hcl"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "vsphere" {
    user = var.vc_user
    password = var.vc_password
    vsphere_server = var.vc_url
    allow_unverified_ssl = true
  }
EOF
}

remote_state {
  backend = "local"

  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite"
  }

  config = {
    path = "${path_relative_to_include()}/terraform.tfstate"
  }
}
