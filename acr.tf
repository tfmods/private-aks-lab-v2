/* 
data "azurerm_resource_group" "acr" {
  provider = azurerm.tss
  name     = var.acr_rg_name
  #  location = "eastus2"
}

# Create azure container registry
resource "azurerm_container_registry" "acr" {
  provider                      = azurerm.tss
  name                          = var.acr_name
  location                      = data.azurerm_resource_group.acr.location
  resource_group_name           = data.azurerm_resource_group.acr.name
  admin_enabled                 = false
  sku                           = var.acr_sku
  public_network_access_enabled = false
}


# Create azure private endpoint
resource "azurerm_private_endpoint" "acr_private_endpoint" {
  provider            = azurerm.main
  name                = "${var.acr_name}-private-endpoint"
  resource_group_name = data.azurerm_resource_group.acr.name
  location            = data.azurerm_resource_group.acr.location
  subnet_id           = data.azurerm_subnet.main.id
 

  private_service_connection {
    name                           = "${var.acr_name}-service-connection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names = [
      "registry"
    ]
  }

  private_dns_zone_group {
    name = "${var.acr_name}-private-dns-zone-group"

    private_dns_zone_ids = [
      azurerm_private_dns_zone.acr.id
    ]
  }

  depends_on = [
    azurerm_container_registry.acr
  ]
}


# Create azure container registry private endpoint
resource "azurerm_private_dns_zone" "acr" {
  provider            = azurerm.tss
  name                = local.private_dns_zones.acr
  resource_group_name = data.azurerm_virtual_network.tss.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr-main" {
  #Link com rede do AKS
  provider              = azurerm.tss
  name                  = var.aks_network_dns_link
  resource_group_name   = data.azurerm_virtual_network.tss.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = data.azurerm_virtual_network.main.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr-tss" {
  # Link com rede shared services 
  provider              = azurerm.tss
  name                  = var.aks_network_dns_link_tss
  resource_group_name   = data.azurerm_virtual_network.tss.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = data.azurerm_virtual_network.tss.id
}


resource "azurerm_private_dns_zone_virtual_network_link" "acr-tcn" {
  #link com terra conections
  provider              = azurerm.tss
  name                  = var.aks_network_dns_link_tcn
  resource_group_name   = data.azurerm_virtual_network.tss.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = data.azurerm_virtual_network.tcn.id
} */