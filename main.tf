terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.26"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}