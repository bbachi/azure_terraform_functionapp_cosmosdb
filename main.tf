resource "azurerm_resource_group" "resource_group" {
  name  = var.rg-name
  location = var.location
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "db" {
  name                = var.cosmosdb_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = true
  mongo_server_version= "4.0"

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level  = "Eventual"
  }

  geo_location {
    location          = azurerm_resource_group.resource_group.location
    failover_priority = 0
  }
}

#Create Resource Group
resource "azurerm_storage_account" "fn_storage_account" {
  name                     = var.fn_storage_account_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "fn_app_service_plan" {
  name                = var.fn_app_service_plan_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "fn_app" {
  name                       = var.function_app_name
  location                   = azurerm_resource_group.resource_group.location
  resource_group_name        = azurerm_resource_group.resource_group.name
  app_service_plan_id        = azurerm_app_service_plan.fn_app_service_plan.id
  storage_account_name       = azurerm_storage_account.fn_storage_account.name
  storage_account_access_key = azurerm_storage_account.fn_storage_account.primary_access_key

  app_settings = {
    FUNCTIONS_EXTENSION_VERSION = "~3"
    FUNCTIONS_WORKER_RUNTIME = "node"
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING    = "${azurerm_storage_account.fn_storage_account.primary_connection_string}"
    WEBSITE_CONTENTSHARE                        = "${azurerm_storage_account.fn_storage_account.name}"
    COSMOSDB_CONNECTION_STR = azurerm_cosmosdb_account.db.connection_strings[0]
  }

  depends_on = [azurerm_cosmosdb_account.db]
}