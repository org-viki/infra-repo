output "tfstate_resource_group_id" {
  value = azurerm_resource_group.tfstate.id
}

output "tfstate_storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}

output "tfstate_storage_account_id" {
  value = azurerm_storage_account.tfstate.id
}

# output "bootstrap_container_id" {
#   value = azurerm_storage_container.bootstrap.resource_manager_id
# }

output "dev_container_id" {
  value = azurerm_storage_container.dev.id
}

output "stage_container_id" {
  value = azurerm_storage_container.stage.id
}

output "prod_container_id" {
  value = azurerm_storage_container.prod.id
}

output "tf_dev_client_id" {
  value = azurerm_user_assigned_identity.tf_dev.client_id
}

output "tf_stage_client_id" {
  value = azurerm_user_assigned_identity.tf_stage.client_id
}

output "tf_prod_client_id" {
  value = azurerm_user_assigned_identity.tf_prod.client_id
}