resource_group_name = "rg-dev"
location            = "Central India"

vnet_name = "vnet-dev"

vnet_address_space = [
  "10.10.0.0/16"
]

aks_subnet_name = "snet-aks"

aks_subnet_address_prefixes = [
  "10.10.0.0/20"
]

acr_name = "acrdevvikram001"

aks_name = "aks-dev"

kubernetes_version = "1.35"

dns_prefix = "aks-dev"

node_count = 1

vm_size = "Standard_B2s"