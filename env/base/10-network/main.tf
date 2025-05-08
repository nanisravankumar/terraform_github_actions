terraform {
  backend "azurerm" {
    resource_group_name  = "rg-econ-prod-state"
    storage_account_name = "srsteconprodstate"
    container_name       = "stceconprodstate"
    key                  = "10-network.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "econcloud" {
  name     = "${var.prefix}cloud-resources-${var.environment}"
  location = var.location
  tags     = var.rgtags
}
