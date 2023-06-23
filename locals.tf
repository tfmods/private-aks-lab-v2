locals {
  tss = {
    network = "vn-tss-eastus2"
    rg      = "rg-network-tss-eastus2-01"
  }

  tcn = {
    network = "vn-tcn-br-eastus2"
    rg      = "rg-network-tcn-br-eastus2-01"
  }
}

locals {
  private_dns_zones = {
    kv  = "privatelink.vaultcore.azure.net"
    acr = "privatelink.azurecr.io"
    aks = "privatelink.eastus2.azmk8s.io"
  }
}

locals {

  allowed_ip_ranges = ["110.224.235.2"]

}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.example.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.example.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.example.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.example.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.example.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.example.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.example.name}-rdrcfg"
}