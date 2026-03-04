resource "helm_release" "kube_prometheus_stack" {
  name       = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  namespace        = "monitoring"
  create_namespace = true

  set {
      name  = "grafana.datasources.datasources\\.yaml.datasources[0].url"
      value = "http://monitoring-kube-prometheus-prometheus.monitoring:9090"
  }

  timeout = 1800

  depends_on = [
    azurerm_kubernetes_cluster.poc21
  ]
}
