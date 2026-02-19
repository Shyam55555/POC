############################################
# Existing Resource Group
############################################

data "azurerm_resource_group" "devops" {
  name = "devops"
}

############################################
# Variable for dynamic IP (from Jenkins)
############################################

variable "authorized_ip" {
  description = "Authorized IP address for AKS API access"
  type        = string
}

############################################
# AKS Cluster: poc-21
############################################

resource "azurerm_kubernetes_cluster" "poc21" {

  name                = "poc-21"
  location            = "East US"
  resource_group_name = data.azurerm_resource_group.devops.name
  dns_prefix          = "poc-21-dns"

  kubernetes_version = "1.33.6"

  sku_tier = "Free"

  #########################################
  # Identity
  #########################################

  identity {
    type = "SystemAssigned"
  }

  #########################################
  # Node Pool
  #########################################

  default_node_pool {

    name       = "nodepool1"
    node_count = 1

    vm_size = "Standard_D2als_v6"

    type = "VirtualMachineScaleSets"

    os_disk_size_gb = 30
  }

  #########################################
  # RBAC (Fix AZU-0042)
  #########################################

  role_based_access_control_enabled = true

  #########################################
  # API Server Access Restriction (Fix AZU-0041)
  #########################################

  api_server_access_profile {

    authorized_ip_ranges = [
      var.authorized_ip
    ]

  }

  #########################################
  # Network Profile (Azure CNI Overlay)
  #########################################

  network_profile {

    network_plugin      = "azure"
    network_plugin_mode = "overlay"

    network_policy      = "azure"   # FIX AZU-0043

    pod_cidr       = "10.244.0.0/16"
    service_cidr   = "10.0.0.0/16"
    dns_service_ip = "10.0.0.10"

    load_balancer_sku = "standard"

  }

  #########################################
  # Tags
  #########################################

  tags = {
    Project     = "POC-21"
    Environment = "POC-21"
  }

}
