resource "azurerm_storage_container" "demo" {
  name                  = format("%scontainer", lower(var.domain))
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}