## Durante o desenvolvimento foi necessário criar aliases para lidar com recursos que pudessem estar em uma segunda subscrição.
## Logo criei essa nomenclatura.
## O motivo tecnico era a necessidade de ter o aks em um grupo de recurso e o private dns em outro grupo de recurso linkado em multiplas redes, 
## podendo ser algumas dessas redes provenientes de outra subscription.
terraform {

  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "3.43.0"
      configuration_aliases = [azurerm.main, azurerm.tss, azurerm.tcn]
    }
  }
}
provider "azurerm" {
  //outbound_type https://github.com/terraform-providers/terraform-provider-azurerm/blob/v2.5.0/CHANGELOG.md
  features {}
}

provider "azurerm" {
  alias = "main"
  ## essa main subscription é a subcription onde será feito o deploy do aks do cliente.
  subscription_id = var.main_subscription_id
  features {}
}

provider "azurerm" {
  alias = "prd"
  ## essa main subscription é a subcription onde será feito o deploy do aks do cliente.
  subscription_id = var.prd_subscription_id
  features {}
}

provider "azurerm" {
  alias = "tss"
  ## essa link subscription é a subcription que contem as redes onde será linkado o private dns
  subscription_id = var.tss_subscription_id
  tenant_id       = "3767d0e1-2c4b-461c-867e-7668ab0d7b06"
  features {}
}

provider "azurerm" {
  alias = "tcn"
  ## essa link subscription é a subcription que contem as redes onde será linkado o private dns
  subscription_id = var.tcn_subscription_id
  tenant_id       = "3767d0e1-2c4b-461c-867e-7668ab0d7b06"
  features {}
}