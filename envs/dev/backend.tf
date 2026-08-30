terraform {
  backend "azurerm" {
    # use_cli          = true
    use_azuread_auth = true

   
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstatevikram001"
    container_name       = "dev"
    key                  = "terraform.tfstate"
  }
}