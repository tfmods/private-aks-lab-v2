/* locals {
  private_dns_zones = {
    kv-dev-tbd-eastus2-01 = "privatelink.vaultcore.azure.net"
  }
} */

resource "azurerm_key_vault" "main" {
  provider                      = azurerm.main
  name                          = var.kv_name
  location                      = data.azurerm_resource_group.main.location
  resource_group_name           = data.azurerm_resource_group.main.name
  enabled_for_disk_encryption   = true
  tenant_id                     = data.azurerm_subscription.main.tenant_id
  enable_rbac_authorization     = false
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  sku_name                      = "standard"
  public_network_access_enabled = false

  access_policy {
    tenant_id = data.azurerm_client_config.main.tenant_id
    object_id = data.azurerm_client_config.main.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = local.allowed_ip_ranges
  }
  /* access_policy {
  } */

  /* network_acls {
    default_action             = "Deny"
    virtual_network_subnet_ids = [data.azurerm_virtual_network.main.id]
    bypass = None
  } */
}

/* resource "azurerm_key_vault_access_policy" "aks" {
  provider        = azurerm.main
  key_vault_id    = azurerm_key_vault.main.id
  tenant_id       = data.azurerm_subscription.main.tenant_id
  object_id       = data.azurerm_user_assigned_identity.aks.id
  key_permissions = ["Create", "Get", "List", "Purge", "Recover", ]
} */



/* resource "azurerm_key_vault_access_policy" "main" {
 
        secret_permissions = ["Get", "List", "Purge", "Recover", "Set"]
        certificate_permissions = ["Create", "Get", "List", "Purge", "Recover", "Update"]
  ] */



resource "azurerm_private_endpoint" "main" {
  provider            = azurerm.main
  name                = "${var.kv_name}-pe-01"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  subnet_id           = data.azurerm_subnet.main.id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.kv.id]
  }

  private_service_connection {
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.main.id
    name                           = "${azurerm_key_vault.main.name}-service-connection"
    subresource_names              = ["vault"]
  }



  depends_on = [
    module.aks,
  azurerm_key_vault.main]
}



data "azurerm_private_dns_zone" "kv" {
  provider            = azurerm.tss
  name                = local.private_dns_zones.kv
  resource_group_name = data.azurerm_virtual_network.tss.resource_group_name
}

## Zona privada do KV 

/* 
resource "azurerm_private_dns_zone_virtual_network_link" "kv-main" {
  #Link com rede do AKS
  provider              = azurerm.tss
  name                  = var.aks_network_dns_link
  resource_group_name   = data.azurerm_virtual_network.tss.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.kv.name
  virtual_network_id    = data.azurerm_virtual_network.main.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv-tss" {
  # Link com rede shared services 
  provider              = azurerm.tss
  name                  = var.aks_network_dns_link_tss
  resource_group_name   = data.azurerm_virtual_network.tss.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.kv.name
  virtual_network_id    = data.azurerm_virtual_network.tss.id
}


resource "azurerm_private_dns_zone_virtual_network_link" "kv-tcn" {
  #link com terra conections
  provider              = azurerm.tss
  name                  = var.aks_network_dns_link_tcn
  resource_group_name   = data.azurerm_virtual_network.tss.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.kv.name
  virtual_network_id    = data.azurerm_virtual_network.tcn.id
} */