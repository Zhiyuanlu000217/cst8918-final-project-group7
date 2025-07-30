# AKS Clusters Module - Azure Kubernetes Service Clusters
# This module creates test and production AKS clusters for the CST8918 Final Project

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Test AKS Cluster
# tfsec:ignore:azure-container-limit-authorized-ips - Demo project needs GitHub Actions access
resource "azurerm_kubernetes_cluster" "test" {
  name                = var.test_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.test_cluster_name

  # Default node pool configuration
  default_node_pool {
    name                = "default"
    node_count          = var.test_node_count
    vm_size             = var.test_vm_size
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = false
    vnet_subnet_id      = var.test_subnet_id
  }

  # Network profile
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = "172.16.0.0/16"
    dns_service_ip    = "172.16.0.10"
  }

  # Identity
  identity {
    type = "SystemAssigned"
  }

  # Enable RBAC
  role_based_access_control_enabled = true

  # API Server Access Profile - restrict access to GitHub Actions IPs and common CI/CD ranges
  api_server_access_profile {
    authorized_ip_ranges = [
      "20.42.0.0/16",    # GitHub Actions runners (partial range)
      "20.118.0.0/16",   # GitHub Actions runners (partial range)  
      "52.86.0.0/16",    # Common CI/CD ranges
      "13.107.42.14/32", # GitHub API
      "140.82.112.0/20"  # GitHub services
    ]
  }

  # Enable logging with OMS Agent
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  }

  # Kubernetes version
  kubernetes_version = var.kubernetes_version

  # Tags
  tags = merge(var.tags, {
    Environment = "Test"
    ClusterType = "Test"
  })
}

# Production AKS Cluster
# tfsec:ignore:azure-container-limit-authorized-ips - Demo project needs GitHub Actions access
resource "azurerm_kubernetes_cluster" "prod" {
  name                = var.prod_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.prod_cluster_name

  # Default node pool configuration
  default_node_pool {
    name                = "default"
    node_count          = var.prod_min_node_count
    vm_size             = var.prod_vm_size
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = var.prod_min_node_count
    max_count           = var.prod_max_node_count
    vnet_subnet_id      = var.prod_subnet_id
  }

  # Network profile
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = "172.18.0.0/16"
    dns_service_ip    = "172.18.0.10"
  }

  # Identity
  identity {
    type = "SystemAssigned"
  }

  # Enable RBAC
  role_based_access_control_enabled = true

  # API Server Access Profile - restrict access to GitHub Actions IPs and common CI/CD ranges  
  api_server_access_profile {
    authorized_ip_ranges = [
      "20.42.0.0/16",    # GitHub Actions runners (partial range)
      "20.118.0.0/16",   # GitHub Actions runners (partial range)  
      "52.86.0.0/16",    # Common CI/CD ranges
      "13.107.42.14/32", # GitHub API
      "140.82.112.0/20"  # GitHub services
    ]
  }

  # Enable logging with OMS Agent
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  }

  # Kubernetes version
  kubernetes_version = var.kubernetes_version

  # Tags
  tags = merge(var.tags, {
    Environment = "Production"
    ClusterType = "Production"
  })
}

# Log Analytics Workspace for AKS logging
resource "azurerm_log_analytics_workspace" "aks" {
  name                = "aks-logs-workspace"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

# User assigned identity for cluster operations
resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "aks-identity"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
} 