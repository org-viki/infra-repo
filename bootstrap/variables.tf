variable "location" {
  description = "Azure region"
  type        = string
  default     = "Central India"
}

variable "tfstate_resource_group_name" {
  description = "Resource group used for Terraform state"
  type        = string
  default     = "rg-tfstate"
}

variable "tfstate_storage_account_name" {
  description = "Globally unique Azure Storage Account name"
  type        = string
}