locals {
  tss = {
    network = "vn-tss-eastus2"
    rg      = "rg-network-tss-eastus2-01"
  }

  tcn = {
    network = "vn-tcn-br-eastus2"
    rg      = "rg-network-tcn-br-eastus2-01"
  }

  prd = {
    network = "vn-tbp-eastus2"
    rg      = "rg-network-tbp-eastus2-01"
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
  backend_address_pool_name      = "${data.azurerm_virtual_network.main.name}-beap"
  frontend_port_name_http        = "${data.azurerm_virtual_network.main.name}-feport-http"
  frontend_port_name_https       = "${data.azurerm_virtual_network.main.name}-feport-https"
  frontend_ip_configuration_name = "${data.azurerm_virtual_network.main.name}-feip"
  http_setting_name              = "${data.azurerm_virtual_network.main.name}-be-htst"
  listener_name                  = "${data.azurerm_virtual_network.main.name}-httplstn"
  listener_name_s                = "${data.azurerm_virtual_network.main.name}-httpslstn"
  request_routing_rule_name      = "${data.azurerm_virtual_network.main.name}-rqrt"
  redirect_configuration_name    = "${data.azurerm_virtual_network.main.name}-rdrcfg"
}