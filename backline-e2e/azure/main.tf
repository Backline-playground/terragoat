# Minimal Azure root for the Backline IaC remediation e2e.
#
# terragoat's own terraform/azure root predates azurerm 4 and no longer validates
# against it (azurerm_app_service_plan and the AKS addon_profile block are gone), so
# it cannot exercise a fix. This root pins azurerm 4 because the remediation specs
# target its attribute names, e.g. https_traffic_only_enabled.
#
# Nothing here is ever applied or planned: state is seeded by e2e/iac/seed-azure-state.sh
# and Azure roots are never planned.

terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "22222222-2222-2222-2222-222222222222"
}

resource "azurerm_resource_group" "example" {
  name     = "terragoat-resources"
  location = "eastus"
}

# Deliberately missing https_traffic_only_enabled and min_tls_version: that gap is
# what enable_encryption_in_transit fixes.
resource "azurerm_storage_account" "example" {
  name                     = "tgsadev12345"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
