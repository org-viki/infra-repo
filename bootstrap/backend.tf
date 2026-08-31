terraform {
  backend "azurerm" {
    # use_cli = true 
    use_azuread_auth     = true
    subscription_id      = "e2fc2850-80df-42a0-87f0-130f871a996a"
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstatevikram001"
    container_name       = "bootstrap"
    key                  = "terraform.tfstate"
  }
}


