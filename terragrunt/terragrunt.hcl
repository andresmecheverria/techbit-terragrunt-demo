skip = true

remote_state {
  backend = "azurerm"
  disable_dependency_optimization = true
  config = merge(local.remote_state, {
    key = local.state_key
  })
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform {

  before_hook "init" {
    commands = ["plan", "apply", "import", "refresh", "init"]
    execute  = ["sh", "${get_parent_terragrunt_dir()}/../scripts/credentials.sh"]
  }

  before_hook "init" {
    commands = ["plan", "apply", "import", "refresh"]
    execute  = ["terraform", "get", "-update"]
  }

  before_hook "fmt" {
    commands = ["plan", "init", "apply"]
    execute  = ["terraform", "fmt", "-recursive"]
  }

  extra_arguments "no_plan_lock" {
    commands = ["plan"]
    arguments = ["-lock=false"]
  }

#  after_hook "after_hook" {
#    commands = ["destroy"]
#    execute  = ["sh", "${get_parent_terragrunt_dir()}/../scripts/delete_all_cache_files.sh", "${local.retrieve_env_reg}", "${path_relative_to_include()}"]
#  }
}

locals {
  remote_state = yamldecode(file("state.yaml"))
  state_key = "terragrunt-demo/${path_relative_to_include()}/terraform.tfstate"
  retrieve_env_reg = split("/", path_relative_to_include()) // Example of the result:  ["solution-demo","prod","northeurope","base"]
}

