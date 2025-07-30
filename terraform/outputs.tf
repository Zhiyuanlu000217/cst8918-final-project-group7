# Root Terraform Outputs
# Outputs from all modules for the CST8918 Final Project

# Backend outputs
output "backend_storage_account_name" {
  description = "Name of the storage account used for Terraform backend"
  value       = module.backend.storage_account_name
}

output "backend_container_name" {
  description = "Name of the blob container used for Terraform state"
  value       = module.backend.container_name
}

# Network outputs
output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.network.vnet_name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.network.vnet_id
}

output "test_subnet_id" {
  description = "ID of the test subnet"
  value       = module.network.subnet_ids.test
}

output "prod_subnet_id" {
  description = "ID of the production subnet"
  value       = module.network.subnet_ids.prod
}

# AKS outputs
output "test_cluster_name" {
  description = "Name of the test AKS cluster"
  value       = module.aks_clusters.test_cluster_name
}

output "prod_cluster_name" {
  description = "Name of the production AKS cluster"
  value       = module.aks_clusters.prod_cluster_name
}

output "test_cluster_id" {
  description = "ID of the test AKS cluster"
  value       = module.aks_clusters.test_cluster_id
}

output "prod_cluster_id" {
  description = "ID of the production AKS cluster"
  value       = module.aks_clusters.prod_cluster_id
}

# Remix Weather App outputs
output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = module.remix_weather_app.acr_name
}

output "acr_login_server" {
  description = "Login server URL for the Azure Container Registry"
  value       = module.remix_weather_app.acr_login_server
}

output "test_redis_name" {
  description = "Name of the test environment Redis cache"
  value       = module.remix_weather_app.test_redis_name
}

output "prod_redis_name" {
  description = "Name of the production environment Redis cache"
  value       = module.remix_weather_app.prod_redis_name
}

output "kubernetes_namespace" {
  description = "Name of the Kubernetes namespace"
  value       = module.remix_weather_app.kubernetes_namespace
}

output "test_deployment_name" {
  description = "Name of the test environment deployment"
  value       = module.remix_weather_app.test_deployment_name
}

output "prod_deployment_name" {
  description = "Name of the production environment deployment"
  value       = module.remix_weather_app.prod_deployment_name
}

output "test_service_name" {
  description = "Name of the test environment service"
  value       = module.remix_weather_app.test_service_name
}

output "prod_service_name" {
  description = "Name of the production environment service"
  value       = module.remix_weather_app.prod_service_name
}

output "test_ingress_name" {
  description = "Name of the test environment ingress"
  value       = module.remix_weather_app.test_ingress_name
}

output "prod_ingress_name" {
  description = "Name of the production environment ingress"
  value       = module.remix_weather_app.prod_ingress_name
}

output "container_image_repository" {
  description = "Full container image repository URL"
  value       = module.remix_weather_app.container_image_repository
}

output "infrastructure_summary" {
  description = "Summary of the complete infrastructure"
  value = {
    backend = {
      storage_account = module.backend.storage_account_name
      container       = module.backend.container_name
    }
    network = {
      vnet_name = module.network.vnet_name
      vnet_id   = module.network.vnet_id
    }
    aks = {
      test_cluster = module.aks_clusters.test_cluster_name
      prod_cluster = module.aks_clusters.prod_cluster_name
    }
    app = module.remix_weather_app.infrastructure_summary
  }
} 