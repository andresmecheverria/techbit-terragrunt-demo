# Provided from common tfvars - {root}/terragrunt/solution-demo/common.tfvars
variable "project" {
  type        = string
  description = "Project id label"
}

# Provided from env-location tfvars - {root}/terragrunt/solution-demo/dev/weu1/terraform.tfvars
variable "domain" {
  type        = string
  description = "Input domain development team"
}

# Provided from env HCL definition {root}/terragrunt/solution-demo/dev/weu1/env.hcl
variable "env" {
  type        = string
  description = "Targe environment short id"
}
variable "location_name" {
  type        = string
  description = "Input location name for deployment"
}
variable "location_id" {
  type        = string
  description = "Input location id for deployment"
}

# Provided from globals HCL definition {root}/terragrunt/solution-demo/globals.hcl
variable "tags" {
  type        = map(string)
  description = "This are the input tags for deployment"
}