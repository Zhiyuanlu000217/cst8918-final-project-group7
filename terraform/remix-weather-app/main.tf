# Remix Weather App Module - Infrastructure
# This module creates the infrastructure needed to deploy the Remix Weather App
# Includes ACR, Redis Cache, and Kubernetes deployments

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  # Use AKS context when available, fallback to local config
  config_path = var.kube_config_path != null ? var.kube_config_path : "~/.kube/config"
}

# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = var.tags
}

# Test Environment Redis Cache
resource "azurerm_redis_cache" "test" {
  name                = var.test_redis_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  minimum_tls_version = "1.2"

  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }

  tags = merge(var.tags, {
    Environment = "Test"
    Purpose     = "Weather-App-Cache"
  })
}

# Production Environment Redis Cache
resource "azurerm_redis_cache" "prod" {
  name                = var.prod_redis_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 1
  family              = "C"
  sku_name            = "Basic"
  minimum_tls_version = "1.2"

  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }

  tags = merge(var.tags, {
    Environment = "Production"
    Purpose     = "Weather-App-Cache"
  })
}

# Kubernetes Namespace for the weather app
resource "kubernetes_namespace" "weather_app" {
  metadata {
    name = var.kubernetes_namespace
    labels = {
      app     = "weather-app"
      project = "cst8918-final-project"
    }
  }
}

# Kubernetes Secret for Redis connection strings
resource "kubernetes_secret" "redis_connection" {
  metadata {
    name      = "redis-connection"
    namespace = kubernetes_namespace.weather_app.metadata[0].name
  }

  data = {
    test_redis_url = "rediss://:${azurerm_redis_cache.test.primary_access_key}@${azurerm_redis_cache.test.hostname}:${azurerm_redis_cache.test.ssl_port}"
    prod_redis_url = "rediss://:${azurerm_redis_cache.prod.primary_access_key}@${azurerm_redis_cache.prod.hostname}:${azurerm_redis_cache.prod.ssl_port}"
  }

  type = "Opaque"
}

# Kubernetes Secret for Weather API Key
resource "kubernetes_secret" "weather_api_key" {
  metadata {
    name      = "weather-api-key"
    namespace = kubernetes_namespace.weather_app.metadata[0].name
  }

  data = {
    WEATHER_API_KEY = var.weather_api_key
  }

  type = "Opaque"
}

# Test Environment Deployment
resource "kubernetes_deployment" "weather_app_test" {
  metadata {
    name      = "weather-app-test"
    namespace = kubernetes_namespace.weather_app.metadata[0].name
    labels = {
      app     = "weather-app"
      env     = "test"
      version = var.app_version
    }
  }

  spec {
    replicas = var.test_replicas

    selector {
      match_labels = {
        app = "weather-app-test"
      }
    }

    template {
      metadata {
        labels = {
          app     = "weather-app-test"
          version = var.app_version
        }
      }

      spec {
        container {
          image = "${azurerm_container_registry.acr.login_server}/weather-app:${var.app_version}"
          name  = "weather-app"

          port {
            container_port = 3000
          }

          env {
            name  = "NODE_ENV"
            value = "production"
          }

          env {
            name  = "PORT"
            value = "3000"
          }

          env {
            name = "WEATHER_API_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.weather_api_key.metadata[0].name
                key  = "WEATHER_API_KEY"
              }
            }
          }

          env {
            name = "REDIS_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.redis_connection.metadata[0].name
                key  = "test_redis_url"
              }
            }
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }

        image_pull_secrets {
          name = kubernetes_secret.acr_credentials.metadata[0].name
        }
      }
    }
  }
}

# Production Environment Deployment
resource "kubernetes_deployment" "weather_app_prod" {
  metadata {
    name      = "weather-app-prod"
    namespace = kubernetes_namespace.weather_app.metadata[0].name
    labels = {
      app     = "weather-app"
      env     = "prod"
      version = var.app_version
    }
  }

  spec {
    replicas = var.prod_replicas

    selector {
      match_labels = {
        app = "weather-app-prod"
      }
    }

    template {
      metadata {
        labels = {
          app     = "weather-app-prod"
          version = var.app_version
        }
      }

      spec {
        container {
          image = "${azurerm_container_registry.acr.login_server}/weather-app:${var.app_version}"
          name  = "weather-app"

          port {
            container_port = 3000
          }

          env {
            name  = "NODE_ENV"
            value = "production"
          }

          env {
            name  = "PORT"
            value = "3000"
          }

          env {
            name = "WEATHER_API_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.weather_api_key.metadata[0].name
                key  = "WEATHER_API_KEY"
              }
            }
          }

          env {
            name = "REDIS_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.redis_connection.metadata[0].name
                key  = "prod_redis_url"
              }
            }
          }

          resources {
            limits = {
              cpu    = "1000m"
              memory = "1Gi"
            }
            requests = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }

        image_pull_secrets {
          name = kubernetes_secret.acr_credentials.metadata[0].name
        }
      }
    }
  }
}

# ACR Credentials Secret for Kubernetes
resource "kubernetes_secret" "acr_credentials" {
  metadata {
    name      = "acr-credentials"
    namespace = kubernetes_namespace.weather_app.metadata[0].name
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${azurerm_container_registry.acr.login_server}" = {
          username = azurerm_container_registry.acr.admin_username
          password = azurerm_container_registry.acr.admin_password
          auth     = base64encode("${azurerm_container_registry.acr.admin_username}:${azurerm_container_registry.acr.admin_password}")
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

# Test Environment Service
resource "kubernetes_service" "weather_app_test" {
  metadata {
    name      = "weather-app-test-service"
    namespace = kubernetes_namespace.weather_app.metadata[0].name
    labels = {
      app = "weather-app-test"
    }
  }

  spec {
    selector = {
      app = "weather-app-test"
    }

    port {
      port        = 80
      target_port = 3000
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# Production Environment Service
resource "kubernetes_service" "weather_app_prod" {
  metadata {
    name      = "weather-app-prod-service"
    namespace = kubernetes_namespace.weather_app.metadata[0].name
    labels = {
      app = "weather-app-prod"
    }
  }

  spec {
    selector = {
      app = "weather-app-prod"
    }

    port {
      port        = 80
      target_port = 3000
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# Test Environment Ingress
resource "kubernetes_ingress_v1" "weather_app_test" {
  metadata {
    name      = "weather-app-test-ingress"
    namespace = kubernetes_namespace.weather_app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
    }
  }

  spec {
    rule {
      host = var.test_domain
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.weather_app_test.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

# Production Environment Ingress
resource "kubernetes_ingress_v1" "weather_app_prod" {
  metadata {
    name      = "weather-app-prod-ingress"
    namespace = kubernetes_namespace.weather_app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }

  spec {
    rule {
      host = var.prod_domain
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.weather_app_prod.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
} 