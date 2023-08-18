#PRIVATE LINKS
aks_azurerm_private_dns_zone = "privatelink.eastus2.azmk8s.io"
kv_azurerm_private_dns_zone  = "privatelink.vaultcore.azure.net"
aks_network_dns_link         = "dsv-aks-link"
acr_rg_name                  = "rg-acr-tss-001"

#IDENTIDADES
aks_managed_identity     = "aks-dev-tbd-eastus2-01"
aks_managed_identity_hlg = "aks-hlg-tbd-eastus2-01"
aks_managed_identity_prd = "aks-prd-tbp-eastus2-01"

aks_managed_identity_kv = "azurekeyvaultsecretsprovider-aks-dev-tbd-eastus2-01"

##Subnets
aks_subnet     = "snet-tbd-eastus2-005"
aks_subnet_hlg = "snet-tbd-eastus2-005"
aks_subnet_prd = "snet-tbp-eastus2-005"

aks_vnet     = "vn-tbd-eastus2"
aks_vnet_prd = "vn-tbp-eastus2"
kv_subnet    = "snet-tss-eastus2-001"
kv_vnet      = "vn-tss-eastus2"
kv_subnet_rg = "rg-network-tss-eastus2-01"

appgw_subnet    = "AppGw"
appgw_vnet      = "vn-tbd-eastus2"
appgw_subnet_rg = "rg-network-tbd-eastus2-01"

aks_network_dns_link_tcn = "link-tcn"
aks_network_dns_link_tss = "link-tss"
aks_network_rg           = "rg-network-tbd-eastus2-01"
aks_network_rg_prd       = "rg-network-tbp-eastus2-01"
waf_policy_name          = "dev-waf-policy-tbd-eastus2-01"
appgw_name               = "dev-appgw-tbd-eastus2-01"
acr_sku                  = "standard"

#appgw_vnet_name = "vn-tbd-eastus2"
aks_rg_name     = "rg-dsv-aks"
aks_rg_name_hlg = "rg-hlg-aks"
aks_rg_name_prd = "rg-prd-aks"
proxy_url       = "http://proxy-az.tpn.terra.com:8080/"

no_proxy = ["localhost",
  "127.0.0.1",
  ".privatelink.eastus2.azmk8s.io",
  ".terra.com",
  ".terra.com.br",
]

tss_subscription_id  = "2d4a11ab-535f-464e-9bed-fad7b59415bf"
tcn_subscription_id  = "1fb655d7-c55e-4950-bd7e-7ca52452eee1"
main_subscription_id = "f08b1fe3-f4f7-4c0a-bb51-d6a47cf1a81c"
prd_subscription_id = "b6588753-4ac6-42bf-b601-c591779c15d3"

acr_name = "acrtpn001"
kv_name  = "kv-dev-tbd-eastus2-01"