output "storage" {
  value = {
    name = azurerm_storage_account.demo.name
    id   = azurerm_storage_account.demo.id
  }
}

output "storage_container_name" {
  value = module.storage_account_container.container_name
}
