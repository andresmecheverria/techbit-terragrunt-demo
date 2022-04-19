include {
  path = find_in_parent_folders()
  expose = true
}

dependency "layerBase" {
  config_path = "${get_terragrunt_dir()}/../layerBase"
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

    arguments = [
      "-var-file=${get_parent_terragrunt_dir()}/common.tfvars",
      "-var-file=${get_terragrunt_dir()}/../terraform.tfvars"
    ]
  }

  after_hook "rm_backend_tf" {
    commands = ["apply", "destroy"]
    execute  = [
      "rm",
      "-rf",
      "${get_terragrunt_dir()}/../**/*/.terragrunt-cache",
      "${get_terragrunt_dir()}/../**/*/.terraform.lock.hcl"
    ]
    run_on_error = true
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
