locals {
  sa_name           = replace(format("sa%s%s%s", lower(var.project), lower(var.env), var.location_id), "-","")
  sa_container_name = replace(format("sa-container-%s-%s-%s-%s", lower(var.project), lower(var.domain), lower(var.env), var.location_id), "-", "")
  tags = merge(
    var.tags,
    {
      "CUSTOM_MODULE_TAGS" = "Hello techbit"
    }
  )
}

resource "azurerm_storage_account" "demo" {
  name                     = local.sa_name
  resource_group_name      = var.resource_group_name
  location                 = var.location_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false

  network_rules {
    default_action = "Allow"
  }
  tags = local.tags
}

module "storage_account_container" {
  source               = "../modules/sa-container"
  storage_account_name = azurerm_storage_account.demo.name
  domain               = var.domain
}
