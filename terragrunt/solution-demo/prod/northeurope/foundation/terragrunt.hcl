include {
  path = find_in_parent_folders()
}

dependency "layerBase" {
  config_path = "${get_terragrunt_dir()}/../base"
  mock_outputs = {
    base_resource_group_name = "mock_resource_group"
  }
}

locals {
  global_vars = read_terragrunt_config(find_in_parent_folders("globals.hcl"))
  global_tags = local.global_vars.locals.global_tags

  env_vars        = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env             = local.env_vars.locals.env
  location_name   = local.env_vars.locals.location_name
  location_id     = local.env_vars.locals.location_id
}

terraform {
  source = "${path_relative_from_include()}/../terraform//foundation"

  extra_arguments "common_vars" {
    commands = [
      "apply",
      "plan",
      "destroy",
      "import",
      "push",
      "refresh"
    ]
    // Only for demo purposes, add to show that it will overwrite the deepest tfvar file (Layer one)
    // As a result: it depends also the order of the argument, it is not the same to put /../terraform.tfvars in index 1 than in 2.
    // In order for it to correctly overwrite it, it is necessary to organize the array with the correct order of hierarchy. parent-tfvar (common) - env-reg tfvar - env-reg-module tfvar.
    arguments = [
      "-var-file=${get_parent_terragrunt_dir()}/common.tfvars", // 0
      "-var-file=${get_terragrunt_dir()}/../terraform.tfvars", // 1
      #"-var-file=${get_terragrunt_dir()}/terraform.tfvars"  // 2 - Enable this from array to overwrite 1-tfvars values.
    ]
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
  resource_group_name = dependency.layerBase.outputs.base_resource_group_name
  env                 = local.env
  location_name       = local.location_name
  location_id         = local.location_id
  tags                = local.global_tags
}
