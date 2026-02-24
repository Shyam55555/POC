############################################
# Use existing Resource Group
############################################

data "azurerm_resource_group" "devops" {
  name = "devops"
}

############################################
# AKS Cluster - Minimal Configuration
############################################

resource "azurerm_kubernetes_cluster" "poc21" {

  name                = "poc-21"
  location            = data.azurerm_resource_group.devops.location
  resource_group_name = data.azurerm_resource_group.devops.name
  dns_prefix          = "poc-21-dns"

  ##################################
  # Identity
  ##################################

  identity {
    type = "SystemAssigned"
  }

  ##################################
  # Node Pool
  ##################################

  default_node_pool {
    name       = "nodepool1"
    node_count = 1
    vm_size    = "Standard_D2als_v6"
  }

  ##################################
  # Security fixes (required for Trivy)
  ##################################

  role_based_access_control_enabled = true

  api_server_access_profile {
    authorized_ip_ranges = [
      var.authorized_ip
    ]
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

}
