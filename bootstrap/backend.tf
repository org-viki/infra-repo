terraform {
  backend "azurerm" {
    # use_cli = true 
    # use_azuread_auth = true

    subscription_id      = ${{ vars.subscrption_id }}
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstatevikram001"
    container_name       = "bootstrap"
    key                  = "terraform.tfstate"
  }
}