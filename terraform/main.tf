resource "azurerm_resource_group" "poc21_rg" {
  name     = "POC-21-rg"
  location = "Central India"
}

resource "azurerm_kubernetes_cluster" "poc21_aks" {

  name                = "POC-21-aks"
  location            = azurerm_resource_group.poc21_rg.location
  resource_group_name = azurerm_resource_group.poc21_rg.name
  dns_prefix          = "poc21"

  # ✅ FIX 1: Enable RBAC
  role_based_access_control_enabled = true

  default_node_pool {
    name            = "poc21node"
    node_count      = 2
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

  # ✅ FIX 2: Restrict API Server Access
  api_server_access_profile {
    authorized_ip_ranges = [
      var.authorized_ip
    ]
  }

  # ✅ FIX 3: Enable Network Policy
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "POC-21"
    Project     = "POC-21"
  }
}
