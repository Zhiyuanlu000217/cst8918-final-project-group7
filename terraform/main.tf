# Root Terraform Configuration
# This orchestrates all modules for the CST8918 Final Project

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Backend configuration for remote state storage
  backend "azurerm" {
    resource_group_name  = "cst8918-backend-rg"
    storage_account_name = "cst8918tfstate"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Backend Module - Azure Blob Storage for Terraform state
module "backend" {
  source = "./backend"

  resource_group_name  = "cst8918-backend-rg"
  location             = var.location
  storage_account_name = var.storage_account_name
  container_name       = var.container_name
  enable_resource_lock = var.enable_resource_lock
}

# Network Module - Base network infrastructure
module "network" {
  source = "./network"

  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  tags                = var.tags
}

# AKS Clusters Module - Kubernetes clusters for test and production
module "aks_clusters" {
  source = "./aks-clusters"

  resource_group_name = var.resource_group_name
  location            = var.location
  test_cluster_name   = var.test_cluster_name
  prod_cluster_name   = var.prod_cluster_name
  test_node_count     = var.test_node_count
  prod_min_node_count = var.prod_min_node_count
  prod_max_node_count = var.prod_max_node_count
  test_vm_size        = var.test_vm_size
  prod_vm_size        = var.prod_vm_size
  kubernetes_version  = var.kubernetes_version
  test_subnet_id      = module.network.subnet_ids.test
  prod_subnet_id      = module.network.subnet_ids.prod
  tags                = var.tags
}

# Remix Weather App Module - Application infrastructure
module "remix_weather_app" {
  source = "./remix-weather-app"

  resource_group_name  = var.resource_group_name
  location             = var.location
  acr_name             = var.acr_name
  test_redis_name      = var.test_redis_name
  prod_redis_name      = var.prod_redis_name
  kubernetes_namespace = var.kubernetes_namespace
  weather_api_key      = var.weather_api_key
  app_version          = var.app_version
  test_replicas        = var.test_replicas
  prod_replicas        = var.prod_replicas
  test_domain          = var.test_domain
  prod_domain          = var.prod_domain
  kube_config_path     = var.kube_config_path
  tags                 = var.tags
} 