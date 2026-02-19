output "aks_name" {
  value = azurerm_kubernetes_cluster.poc21.name
}

output "aks_resource_group" {
  value = data.azurerm_resource_group.devops.name
}

output "aks_location" {
  value = azurerm_kubernetes_cluster.poc21.location
}
