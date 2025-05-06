terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "mbsmstorageacc"
    container_name       = "terragithubactions"
    key                  = "terraform.tfstate"
    resource_group_name  = "testrg"
    subscription_id      = "8275bd32-2df4-4467-9201-597dbf8e04a5"
  }
}

provider "azurerm" {
  features {}
}
