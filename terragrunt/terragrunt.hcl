skip = true

remote_state {
  backend = "azurerm"
  disable_dependency_optimization = true
  config = merge(local.remote_state, {
    key = "terragrunt-demo/${path_relative_to_include()}/terraform.tfstate"
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

  after_hook "rm_backend_tf" {
    commands = ["apply", "destroy", "plan"]
    execute  = [
      "rm",
      "-rf",
      "${get_parent_terragrunt_dir()}/.terraform"
    ]
    run_on_error = true
  }
}

locals {
  remote_state = yamldecode(file("state.yaml"))
}
