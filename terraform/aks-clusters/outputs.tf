# AKS Clusters Module Outputs

output "test_cluster_name" {
  description = "Name of the test AKS cluster"
  value       = azurerm_kubernetes_cluster.test.name
}

output "test_cluster_id" {
  description = "ID of the test AKS cluster"
  value       = azurerm_kubernetes_cluster.test.id
}

output "test_cluster_kube_config" {
  description = "Kubeconfig for the test cluster"
  value       = azurerm_kubernetes_cluster.test.kube_config_raw
  sensitive   = true
}

output "test_cluster_host" {
  description = "Host of the test cluster"
  value       = azurerm_kubernetes_cluster.test.kube_config.0.host
  sensitive   = true
}

output "prod_cluster_name" {
  description = "Name of the production AKS cluster"
  value       = azurerm_kubernetes_cluster.prod.name
}

output "prod_cluster_id" {
  description = "ID of the production AKS cluster"
  value       = azurerm_kubernetes_cluster.prod.id
}

output "prod_cluster_kube_config" {
  description = "Kubeconfig for the production cluster"
  value       = azurerm_kubernetes_cluster.prod.kube_config_raw
  sensitive   = true
}

output "prod_cluster_host" {
  description = "Host of the production cluster"
  value       = azurerm_kubernetes_cluster.prod.kube_config.0.host
  sensitive   = true
}

output "test_cluster_node_pool" {
  description = "Test cluster node pool configuration"
  value = {
    name                = azurerm_kubernetes_cluster.test.default_node_pool.0.name
    node_count          = azurerm_kubernetes_cluster.test.default_node_pool.0.node_count
    vm_size             = azurerm_kubernetes_cluster.test.default_node_pool.0.vm_size
    enable_auto_scaling = azurerm_kubernetes_cluster.test.default_node_pool.0.enable_auto_scaling
  }
}

output "prod_cluster_node_pool" {
  description = "Production cluster node pool configuration"
  value = {
    name                = azurerm_kubernetes_cluster.prod.default_node_pool.0.name
    node_count          = azurerm_kubernetes_cluster.prod.default_node_pool.0.node_count
    vm_size             = azurerm_kubernetes_cluster.prod.default_node_pool.0.vm_size
    enable_auto_scaling = azurerm_kubernetes_cluster.prod.default_node_pool.0.enable_auto_scaling
    min_count           = azurerm_kubernetes_cluster.prod.default_node_pool.0.min_count
    max_count           = azurerm_kubernetes_cluster.prod.default_node_pool.0.max_count
  }
}

output "clusters_config" {
  description = "Complete configuration for both clusters"
  value = {
    test = {
      name               = azurerm_kubernetes_cluster.test.name
      id                 = azurerm_kubernetes_cluster.test.id
      host               = azurerm_kubernetes_cluster.test.kube_config.0.host
      kubernetes_version = azurerm_kubernetes_cluster.test.kubernetes_version
      node_pool = {
        name                = azurerm_kubernetes_cluster.test.default_node_pool.0.name
        node_count          = azurerm_kubernetes_cluster.test.default_node_pool.0.node_count
        vm_size             = azurerm_kubernetes_cluster.test.default_node_pool.0.vm_size
        enable_auto_scaling = azurerm_kubernetes_cluster.test.default_node_pool.0.enable_auto_scaling
      }
    }
    prod = {
      name               = azurerm_kubernetes_cluster.prod.name
      id                 = azurerm_kubernetes_cluster.prod.id
      host               = azurerm_kubernetes_cluster.prod.kube_config.0.host
      kubernetes_version = azurerm_kubernetes_cluster.prod.kubernetes_version
      node_pool = {
        name                = azurerm_kubernetes_cluster.prod.default_node_pool.0.name
        node_count          = azurerm_kubernetes_cluster.prod.default_node_pool.0.node_count
        vm_size             = azurerm_kubernetes_cluster.prod.default_node_pool.0.vm_size
        enable_auto_scaling = azurerm_kubernetes_cluster.prod.default_node_pool.0.enable_auto_scaling
        min_count           = azurerm_kubernetes_cluster.prod.default_node_pool.0.min_count
        max_count           = azurerm_kubernetes_cluster.prod.default_node_pool.0.max_count
      }
    }
  }
  sensitive = true
} 