resource "azurerm_resource_group" "poc21_rg" {
  name     = "POC-21-rg"
  location = "Central India"
}

resource "azurerm_kubernetes_cluster" "poc21_aks" {
  name                = "POC-21-aks"
  location            = azurerm_resource_group.poc21_rg.location
  resource_group_name = azurerm_resource_group.poc21_rg.name
  dns_prefix          = "poc21"

  default_node_pool {
    name       = "poc21node"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "POC-21"
    Project     = "POC-21"
  }
}

