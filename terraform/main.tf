data "azurerm_resource_group" "devops_rg" {
  name = "devops"
}

resource "azurerm_kubernetes_cluster" "poc21_aks" {

  name                = "POC-21-aks"
  location            = "East US"
  resource_group_name = data.azurerm_resource_group.devops_rg.name
  dns_prefix          = "poc-21-dns"

  # ✅ FIX 1: Enable RBAC
  role_based_access_control_enabled = true

  default_node_pool {
    name            = "poc21node"
    node_count      = 2
    vm_size         = "Standard_D2als_v6"
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
