# AKS Clusters Module Variables

variable "resource_group_name" {
  description = "Name of the resource group for AKS clusters"
  type        = string
  default     = "cst8918-final-project-group-7"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

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

variable "test_vm_size" {
  description = "VM size for test cluster nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "prod_vm_size" {
  description = "VM size for production cluster nodes"
  type        = string
  default     = "Standard_DS2_v2"
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

variable "kubernetes_version" {
  description = "Kubernetes version for the clusters"
  type        = string
  default     = "1.32"
}

variable "test_subnet_id" {
  description = "ID of the test subnet for the test cluster"
  type        = string
}

variable "prod_subnet_id" {
  description = "ID of the production subnet for the production cluster"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Project     = "CST8918-Final-Project"
    ManagedBy   = "Terraform"
    Module      = "AKS-Clusters"
    Purpose     = "Kubernetes-Clusters"
  }
} 