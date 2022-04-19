locals {
  resource_group_name = format("%s-rg-%s-%s-%s", lower(var.project), lower(var.env), lower(var.domain), var.location_name)
  tags = merge(
    var.tags,
    {
      "CUSTOM_BASE_TAG" = "Hello techbit"
    }
  )
}

resource "azurerm_resource_group" "group" {
  name     = local.resource_group_name
  location = var.location_name
  tags     = local.tags
}