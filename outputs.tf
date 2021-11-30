output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
  description = "Name of the resource group"
}

output "cosmosdb_account_id" {
  value = azurerm_cosmosdb_account.db.id
  description = "The id of the cosmosdb account"
}

output "cosmosdb_account_name" {
  value = azurerm_cosmosdb_account.db.name
  description = "The name of the cosmosdb account"
}

output "cosmosdb_account_endpoint" {
  value = azurerm_cosmosdb_account.db.endpoint
  description = "The endpoint of the cosmosdb account"
}

output "function_app_name" {
  value = azurerm_function_app.fn_app.name
  description = "Name of the resource group"
}

output "function_app_id" {
  value = azurerm_function_app.fn_app.id
  description = "Id of the function app"
}