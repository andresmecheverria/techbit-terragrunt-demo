include "root" {
  path = find_in_parent_folders()
  expose = true
}

locals {
  global_vars = read_terragrunt_config(find_in_parent_folders("globals.hcl"))
  global_tags = local.global_vars.locals.global_tags

  env_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env       = local.env_vars.locals.env

  location_name   = local.env_vars.locals.location_name
  location_id     = local.env_vars.locals.location_id
}

terraform {
  source = "${path_relative_from_include()}/../terraform//base"

  extra_arguments "common_vars" {
    commands = [
      "apply",
      "plan",
      "destroy",
      "import",
      "push",
      "refresh"
    ]

    arguments = [
      "-var-file=${get_parent_terragrunt_dir()}/common.tfvars",
      "-var-file=${get_terragrunt_dir()}/../terraform.tfvars"
    ]
  }

  after_hook "after_hook" {
    commands = ["init"]
    execute  = ["sh", "${get_parent_terragrunt_dir()}/../scripts/delete_all_cache_files.sh", "${include.root.locals.retrieve_env_reg[1]}", "${path_relative_to_include()}"]
  }

}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"

  contents = <<EOF
provider "azurerm" {
  features {}
}
EOF
}

inputs = {
  env                 = include.root.locals.retrieve_env_reg[1]
  location_name       = include.root.locals.retrieve_env_reg[2]
  location_id         = local.location_id
  tags                = local.global_tags
}