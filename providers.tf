terraform {
  required_version = ">= 0.14.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.52.0"
    }
  }

  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}