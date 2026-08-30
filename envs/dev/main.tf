terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ---------------------------------------------------------
# Existing Resource Group
# ---------------------------------------------------------

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

# ---------------------------------------------------------
# Network
# ---------------------------------------------------------

module "network" {
  source = "../../modules/network"

  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  vnet_name                   = var.vnet_name
  vnet_address_space          = var.vnet_address_space
  aks_subnet_name             = var.aks_subnet_name
  aks_subnet_address_prefixes = var.aks_subnet_address_prefixes
}

# ---------------------------------------------------------
# ACR
# ---------------------------------------------------------

module "acr" {
  source = "../../modules/acr"

  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  acr_name = var.acr_name
}

# ---------------------------------------------------------
# AKS
# ---------------------------------------------------------

module "aks" {
  source = "../../modules/aks"

  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  aks_name           = var.aks_name
  kubernetes_version = var.kubernetes_version
  subnet_id          = module.network.aks_subnet_id
  dns_prefix         = var.dns_prefix

  node_count = var.node_count
  vm_size    = var.vm_size

  acr_id = module.acr.acr_id
}

# ---------------------------------------------------------
# AKS → ACR
# ---------------------------------------------------------

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_object_id
}