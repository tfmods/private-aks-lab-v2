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

