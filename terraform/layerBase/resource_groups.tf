locals {
  tags = merge(
    var.tags,
    {
      "CUSTOM_BASE_TAG" = "Hello techbit"
    }
  )
}

module "base_resource_group" {
  source = "../modules/resource-group"

  env      = var.env
  location_name = var.location_name
  project  = var.project
  tags     = local.tags
  domain   = var.domain
}