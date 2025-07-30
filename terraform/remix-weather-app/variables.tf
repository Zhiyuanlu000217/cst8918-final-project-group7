# Remix Weather App Module Variables

variable "resource_group_name" {
  description = "Name of the resource group for the weather app infrastructure"
  type        = string
  default     = "cst8918-final-project-group-7"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "cst8918weatheracr"
}

variable "test_redis_name" {
  description = "Name of the test environment Redis cache"
  type        = string
  default     = "cst8918-test-redis"
}

variable "prod_redis_name" {
  description = "Name of the production environment Redis cache"
  type        = string
  default     = "cst8918-prod-redis"
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace for the weather app"
  type        = string
  default     = "weather-app"
}

variable "weather_api_key" {
  description = "OpenWeather API key for the weather app"
  type        = string
  sensitive   = true
  default     = "e8e9794d640431c99ff5273e42596695"
}

variable "app_version" {
  description = "Version tag for the weather app container image"
  type        = string
  default     = "v1.0.0"
}

variable "test_replicas" {
  description = "Number of replicas for the test environment deployment"
  type        = number
  default     = 1
}

variable "prod_replicas" {
  description = "Number of replicas for the production environment deployment"
  type        = number
  default     = 2
}

variable "test_domain" {
  description = "Domain name for the test environment ingress"
  type        = string
  default     = "test-weather.cst8918.com"
}

variable "prod_domain" {
  description = "Domain name for the production environment ingress"
  type        = string
  default     = "weather.cst8918.com"
}

variable "kube_config_path" {
  description = "Path to the Kubernetes config file (optional, defaults to ~/.kube/config)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Project     = "CST8918-Final-Project"
    ManagedBy   = "Terraform"
    Module      = "Remix-Weather-App"
    Purpose     = "Weather-Application-Infrastructure"
  }
} 