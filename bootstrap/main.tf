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
# Resource Group for Terraform Remote State
# ---------------------------------------------------------

resource "azurerm_resource_group" "tfstate" {
  name     = var.tfstate_resource_group_name
  location = var.location
}

# ---------------------------------------------------------
# Storage Account for Terraform State
# ---------------------------------------------------------

resource "azurerm_storage_account" "tfstate" {
  name                     = var.tfstate_storage_account_name
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false

  shared_access_key_enabled = true

  tags = {
    purpose     = "terraform-state"
    environment = "shared"
    managed_by  = "terraform"
  }
}

# ---------------------------------------------------------
# Containers
# ---------------------------------------------------------

resource "azurerm_storage_container" "bootstrap" {
  name                  = "bootstrap"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "dev" {
  name                  = "dev"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "stage" {
  name                  = "stage"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "prod" {
  name                  = "prod"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

# ---------------------------------------------------------
# Terraform UAMI - DEV
# ---------------------------------------------------------

resource "azurerm_user_assigned_identity" "tf_dev" {
  name                = "uami-tf-dev"
  resource_group_name = azurerm_resource_group.tfstate.name
  location            = azurerm_resource_group.tfstate.location

  tags = {
    purpose     = "terraform"
    environment = "dev"
    managed_by  = "terraform"
  }
}

# ---------------------------------------------------------
# Terraform UAMI - STAGE
# ---------------------------------------------------------

resource "azurerm_user_assigned_identity" "tf_stage" {
  name                = "uami-tf-stage"
  resource_group_name = azurerm_resource_group.tfstate.name
  location            = azurerm_resource_group.tfstate.location

  tags = {
    purpose     = "terraform"
    environment = "stage"
    managed_by  = "terraform"
  }
}

# ---------------------------------------------------------
# Terraform UAMI - PROD
# ---------------------------------------------------------

resource "azurerm_user_assigned_identity" "tf_prod" {
  name                = "uami-tf-prod"
  resource_group_name = azurerm_resource_group.tfstate.name
  location            = azurerm_resource_group.tfstate.location

  tags = {
    purpose     = "terraform"
    environment = "prod"
    managed_by  = "terraform"
  }
}

# ---------------------------------------------------------
# State permissions
# ---------------------------------------------------------

resource "azurerm_role_assignment" "tf_dev_state" {
  scope                = azurerm_storage_container.dev.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.tf_dev.principal_id
}

resource "azurerm_role_assignment" "tf_stage_state" {
  scope                = azurerm_storage_container.stage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.tf_stage.principal_id
}

resource "azurerm_role_assignment" "tf_prod_state" {
  scope                = azurerm_storage_container.prod.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.tf_prod.principal_id
}

# ---------------------------------------------------------
# Bootstrap state permission
# ---------------------------------------------------------

# resource "azurerm_role_assignment" "tf_dev_bootstrap_state" {
#   scope                = azurerm_storage_container.bootstrap.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = azurerm_user_assigned_identity.tf_dev.principal_id
# }

resource "azurerm_resource_group" "dev" {
  name     = "rg-dev"
  location = var.location

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

resource "azurerm_resource_group" "stage" {
  name     = "rg-stage"
  location = var.location

  tags = {
    environment = "stage"
    managed_by  = "terraform"
  }
}

resource "azurerm_resource_group" "prod" {
  name     = "rg-prod"
  location = var.location

  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }
}

resource "azurerm_role_assignment" "tf_dev_infra" {
  scope                = azurerm_resource_group.dev.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.tf_dev.principal_id
}

resource "azurerm_role_assignment" "tf_stage_infra" {
  scope                = azurerm_resource_group.stage.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.tf_stage.principal_id
}

resource "azurerm_role_assignment" "tf_prod_infra" {
  scope                = azurerm_resource_group.prod.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.tf_prod.principal_id
}