terraform {
  backend "azurerm" {
    resource_group_name  = "rg-econ-prod-state"
    storage_account_name = "srsteconprodstate"
    container_name       = "stceconprodstate"
    key                  = "10-network.tfstate"
    subscription_id      = "8275bd32-2df4-4467-9201-597dbf8e04a5"
  }
}

provider "azurerm" {
  features {}
  subscription_id      = "8275bd32-2df4-4467-9201-597dbf8e04a5"
}

resource "azurerm_resource_group" "econcloud" {
  name     = "${var.prefix}cloud-resources-${var.environment}"
  location = var.location
  tags     = var.rgtags
}
