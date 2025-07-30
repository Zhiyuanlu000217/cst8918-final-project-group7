# Remix Weather App Module Outputs

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "Login server URL for the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  description = "Admin username for the Azure Container Registry"
  value       = azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
  description = "Admin password for the Azure Container Registry"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}

output "test_redis_name" {
  description = "Name of the test environment Redis cache"
  value       = azurerm_redis_cache.test.name
}

output "test_redis_hostname" {
  description = "Hostname of the test environment Redis cache"
  value       = azurerm_redis_cache.test.hostname
}

output "test_redis_ssl_port" {
  description = "SSL port of the test environment Redis cache"
  value       = azurerm_redis_cache.test.ssl_port
}

output "test_redis_primary_access_key" {
  description = "Primary access key for the test environment Redis cache"
  value       = azurerm_redis_cache.test.primary_access_key
  sensitive   = true
}

output "prod_redis_name" {
  description = "Name of the production environment Redis cache"
  value       = azurerm_redis_cache.prod.name
}

output "prod_redis_hostname" {
  description = "Hostname of the production environment Redis cache"
  value       = azurerm_redis_cache.prod.hostname
}

output "prod_redis_ssl_port" {
  description = "SSL port of the production environment Redis cache"
  value       = azurerm_redis_cache.prod.ssl_port
}

output "prod_redis_primary_access_key" {
  description = "Primary access key for the production environment Redis cache"
  value       = azurerm_redis_cache.prod.primary_access_key
  sensitive   = true
}

output "kubernetes_namespace" {
  description = "Name of the Kubernetes namespace"
  value       = kubernetes_namespace.weather_app.metadata[0].name
}

output "test_deployment_name" {
  description = "Name of the test environment deployment"
  value       = kubernetes_deployment.weather_app_test.metadata[0].name
}

output "prod_deployment_name" {
  description = "Name of the production environment deployment"
  value       = kubernetes_deployment.weather_app_prod.metadata[0].name
}

output "test_service_name" {
  description = "Name of the test environment service"
  value       = kubernetes_service.weather_app_test.metadata[0].name
}

output "prod_service_name" {
  description = "Name of the production environment service"
  value       = kubernetes_service.weather_app_prod.metadata[0].name
}

output "test_ingress_name" {
  description = "Name of the test environment ingress"
  value       = kubernetes_ingress_v1.weather_app_test.metadata[0].name
}

output "prod_ingress_name" {
  description = "Name of the production environment ingress"
  value       = kubernetes_ingress_v1.weather_app_prod.metadata[0].name
}

output "redis_connection_strings" {
  description = "Redis connection strings for both environments"
  value = {
    test = "rediss://:${azurerm_redis_cache.test.primary_access_key}@${azurerm_redis_cache.test.hostname}:${azurerm_redis_cache.test.ssl_port}"
    prod = "rediss://:${azurerm_redis_cache.prod.primary_access_key}@${azurerm_redis_cache.prod.hostname}:${azurerm_redis_cache.prod.ssl_port}"
  }
  sensitive = true
}

output "container_image_repository" {
  description = "Full container image repository URL"
  value       = "${azurerm_container_registry.acr.login_server}/weather-app"
}

output "infrastructure_summary" {
  description = "Summary of the created infrastructure"
  value = {
    acr = {
      name         = azurerm_container_registry.acr.name
      login_server = azurerm_container_registry.acr.login_server
    }
    redis = {
      test = {
        name     = azurerm_redis_cache.test.name
        hostname = azurerm_redis_cache.test.hostname
        sku      = azurerm_redis_cache.test.sku_name
      }
      prod = {
        name     = azurerm_redis_cache.prod.name
        hostname = azurerm_redis_cache.prod.hostname
        sku      = azurerm_redis_cache.prod.sku_name
      }
    }
    kubernetes = {
      namespace = kubernetes_namespace.weather_app.metadata[0].name
      deployments = {
        test = kubernetes_deployment.weather_app_test.metadata[0].name
        prod = kubernetes_deployment.weather_app_prod.metadata[0].name
      }
      services = {
        test = kubernetes_service.weather_app_test.metadata[0].name
        prod = kubernetes_service.weather_app_prod.metadata[0].name
      }
      ingress = {
        test = kubernetes_ingress_v1.weather_app_test.metadata[0].name
        prod = kubernetes_ingress_v1.weather_app_prod.metadata[0].name
      }
    }
  }
} 