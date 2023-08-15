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
#appgw_vnet_name                                 = "vn-tbd-eastus2"
aks_rg_name     = "rg-dsv-aks"
aks_rg_name_hlg = "rg-hlg-aks"
aks_rg_name_prd = "rg-prd-aks"
proxy_url       = "http://10.253.126.72:3128/"
no_proxy = ["localhost",
  "127.0.0.1",
  "10.224.234.0/23",
  "10.225.125.0/25",
  "api.terra.com",
  "api-hlg-priv.terra.com.br",
  "api-priv.terra.com.br",
  ".privatelink.eastus2.azmk8s.io",
  "minio-tpn.terra.com",
  "minio.tpn.terra.com",
  "npm-registry.terra.com",
  "npm-registry.tpn.terra.com",
  "alertmanager-k8s.terra.com",
  "prometheus-k8s.terra.com",
  "kafka-k8s.terra.com",
  "ganesha-hlg.terra.com",
  "renderer-hlg.terra.com",
  "croupier-hlg.terra.com",
  "montador-hlg.terra.com",
  "servicos-hlg.tpn.terra.com",
  "dashboard4p.terra.com",
  "sonarqube.tpn.terra.com",
  "nexus-repo.tpn.terra.com",
  "musa-hlg.tpn.terra.com",
  "musa.tpn.terra.com",
  "musa-adm.terra.com.br",
  "navbar-hlg.tpn.terra.com",
  "navbar.tpn.terra.com",
  "navbar-adm.terra.com.br",
  "navbar.adm.terra.com.br",
  "hlg-ilive.tpn.terra.com",
  "ilive.tpn.terra.com",
  "hlg-painelmayorista.tpn.terra.com",
  "hlg-painelmayorista-pe.tpn.terra.com",
  "hlg-painelmayorista-co.tpn.terra.com",
  "fgc.tpn.terra.com",
  "cengine.tpn.terra.com",
  "elk-svc.tpn.terra.com",
  "kibana-svc.tpn.terra.com",
  "minhasenha.tpn.terra.com",
  "cms.tpn.terra.com",
  "cms.tpn.terra.com",
  "minhasenha.corp.terra.com",
  "micontrasena.corp.terra.com",
  "mypassword.corp.terra.com",
  "dsv-hermes-api.tpn.terra.com",
  "dsv-hermes-frontend.tpn.terra.com",
  "qa-hermes-frontend.tpn.terra.com",
  "qa-hermes-api.tpn.terra.com",
  "hlg-hermes-frontend.tpn.terra.com",
  "hlg-hermes-api.tpn.terra.com",
  "hermes.tpn.terra.com",
  "hermes-api.tpn.terra.com",
  "rt-hlg.tpn.terra.com",
  "uptime-kuma.tpn.terra.com",
  "lb-dsv-azr.tpn.terra.com",
  "google.com"
]

tss_subscription_id  = "2d4a11ab-535f-464e-9bed-fad7b59415bf"
tcn_subscription_id  = "1fb655d7-c55e-4950-bd7e-7ca52452eee1"
main_subscription_id = "f08b1fe3-f4f7-4c0a-bb51-d6a47cf1a81c"
prd_subscription_id = "b6588753-4ac6-42bf-b601-c591779c15d3"

acr_name = "acrtpn001"
kv_name  = "kv-dev-tbd-eastus2-01"