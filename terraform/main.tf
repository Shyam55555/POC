############################################
# Existing Resource Group
############################################

data "azurerm_resource_group" "devops" {
  name = "devops"
}

############################################
# AKS Cluster: poc-21
############################################

resource "azurerm_kubernetes_cluster" "poc21" {

  name                = "poc-21"
  location            = "East US"
  resource_group_name = data.azurerm_resource_group.devops.name
  dns_prefix          = "poc-21-dns"

  kubernetes_version  = "1.33.6"

  #########################################
  # SKU / Pricing Tier
  #########################################

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
  # RBAC
  #########################################

  role_based_access_control_enabled = true

  #########################################
  # Network Configuration
  #########################################

  network_profile {

    network_plugin = "azure"
    network_plugin_mode = "overlay"

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
