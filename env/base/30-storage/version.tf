terraform {
  required_version = "1.11.4" # 1.5.5
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.68.0"
    }
  }
}