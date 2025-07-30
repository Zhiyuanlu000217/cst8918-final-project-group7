# Root Terraform Variables
# Variables for the CST8918 Final Project

variable "resource_group_name" {
  description = "Name of the resource group for all resources"
  type        = string
  default     = "cst8918-final-project-group-7"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

# Backend variables
variable "storage_account_name" {
  description = "Name of the storage account for Terraform backend"
  type        = string
  default     = "cst8918tfstate"
}

variable "container_name" {
  description = "Name of the blob container for Terraform state"
  type        = string
  default     = "terraform-state"
}

variable "enable_resource_lock" {
  description = "Enable resource lock to prevent accidental deletion"
  type        = bool
  default     = true
}

# Network variables
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "cst8918-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
  default     = "10.0.0.0/14"
}

# AKS variables
variable "test_cluster_name" {
  description = "Name of the test AKS cluster"
  type        = string
  default     = "cst8918-test-aks"
}

variable "prod_cluster_name" {
  description = "Name of the production AKS cluster"
  type        = string
  default     = "cst8918-prod-aks"
}

variable "test_node_count" {
  description = "Number of nodes in the test cluster"
  type        = number
  default     = 1
}

variable "prod_min_node_count" {
  description = "Minimum number of nodes in the production cluster"
  type        = number
  default     = 1
}

variable "prod_max_node_count" {
  description = "Maximum number of nodes in the production cluster"
  type        = number
  default     = 3
}

variable "test_vm_size" {
  description = "VM size for test cluster nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "prod_vm_size" {
  description = "VM size for production cluster nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the clusters"
  type        = string
  default     = "1.32"
}

# Remix Weather App variables
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
  default     = 1
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
    Module      = "Root-Configuration"
    Purpose     = "Final-Project-Infrastructure"
  }
} 