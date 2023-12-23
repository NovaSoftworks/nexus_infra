locals {
  component = "novacp-${var.environment}-${var.region_short}-nexus"
}

resource "azurerm_resource_group" "mongo_rg" {
  name     = "${local.component}-mongo-rg"
  location = var.region
}

resource "azurerm_cosmosdb_account" "mongo" {
  name                = "${local.component}-mongo"
  resource_group_name = azurerm_resource_group.mongo_rg.name
  location            = azurerm_resource_group.mongo_rg.location
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = false

  capacity {
    total_throughput_limit = 1000
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = azurerm_resource_group.mongo_rg.location
    failover_priority = 0
  }
}
