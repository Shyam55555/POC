output "poc21_aks_name" {
  value = azurerm_kubernetes_cluster.poc21.name
}

output "poc21_resource_group" {
  value = data.azurerm_resource_group.devops.name
}

output "poc21_location" {
  value = azurerm_kubernetes_cluster.poc21.location
}
