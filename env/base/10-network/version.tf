terraform {
  required_version = "1.5.7"    #"1.11.4" 
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }
}
