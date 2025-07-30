# Network Module Variables

variable "resource_group_name" {
  description = "Name of the resource group for network resources"
  type        = string
  default     = "cst8918-final-project-group-7"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

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

variable "prod_subnet_address_space" {
  description = "Address space for the production subnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "test_subnet_address_space" {
  description = "Address space for the test subnet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dev_subnet_address_space" {
  description = "Address space for the development subnet"
  type        = string
  default     = "10.2.0.0/16"
}

variable "admin_subnet_address_space" {
  description = "Address space for the admin subnet"
  type        = string
  default     = "10.3.0.0/16"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Project     = "CST8918-Final-Project"
    ManagedBy   = "Terraform"
    Module      = "Network"
    Purpose     = "Virtual-Network-Infrastructure"
  }
} 