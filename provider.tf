terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    storage_account_name = "mbsmstorageacc"
    container_name       = "terragithubactions"
    key                  = "terraform.tfstate"
    resource_group_name  = "testrg"
  }
