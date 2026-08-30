resource "azurerm_container_registry" "this" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku           = "Standard"
  admin_enabled = false
}

# Hum ACR admin username/password use nahi karenge.

# AKS ko Azure Managed Identity ke through access denge. AcrPull