terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.7.0"
    }
  }
}

provider "azurerm" {
  subscription_id = ""
  client_id       = ""
  client_secret   = ""  #(value:,secret id:) Use 'client_secret' instead of 'secret'
  tenant_id       = ""
  features {}  # Required block for azurerm provider
}
