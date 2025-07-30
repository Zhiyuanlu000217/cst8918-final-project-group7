# Backend Module - Azure Storage Account for Terraform State
# This module creates the infrastructure needed to store Terraform state remotely

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

# Azure Resource Group
resource "azurerm_resource_group" "backend" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Azure Storage Account
resource "azurerm_storage_account" "backend" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.backend.name
  location                 = azurerm_resource_group.backend.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  # Enable blob public access for state management
  allow_nested_items_to_be_public = false

  tags = var.tags
}

# Blob Container for Terraform State
resource "azurerm_storage_container" "terraform_state" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.backend.name
  container_access_type = "private"
}

# Optional: Add a lock to prevent accidental deletion
resource "azurerm_management_lock" "backend_lock" {
  count      = var.enable_resource_lock ? 1 : 0
  name       = "backend-lock"
  scope      = azurerm_resource_group.backend.id
  lock_level = "CanNotDelete"
  notes      = "Protects the backend infrastructure from accidental deletion"
}

# Backend Configuration for Other Terraform Modules
# To use this backend in other modules, add this to their versions.tf:
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "cst8918-backend-rg"
#     storage_account_name = "cst8918tfstate"
#     container_name       = "terraform-state"
#     key                 = "your-module-name.tfstate"
#   }
# } 