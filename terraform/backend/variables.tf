# Backend Module Variables

variable "resource_group_name" {
  description = "Name of the resource group for the backend infrastructure"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "storage_account_name" {
  description = "Name of the storage account for Terraform state"
  type        = string
}

variable "container_name" {
  description = "Name of the blob container for Terraform state"
  type        = string
  default     = "terraform-state"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Project     = "CST8918-Final-Project"
    ManagedBy   = "Terraform"
  }
}

variable "enable_resource_lock" {
  description = "Enable resource lock to prevent accidental deletion"
  type        = bool
  default     = true
} 