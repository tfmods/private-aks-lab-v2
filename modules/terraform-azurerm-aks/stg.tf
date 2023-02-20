# # Create Private DNS Zone Network Link
# resource "azurerm_storage_account" "main" {
#   count               = var.storage_profile_enabled == null ? 0 : 1
#   name                = "${local.names.aks}stg"
#   resource_group_name = data.azurerm_resource_group.main.name
#   location            = data.azurerm_resource_group.main.location

#   account_kind             = "StorageV2"
#   account_tier             = "Premium"
#   account_replication_type = "LRS"

#    network_rules {
#       default_action = "Deny"
#       ip_rules = var.white_list_ip
#   }
# }

# # Create Private Endpint
# resource "azurerm_private_endpoint" "main" {
#   count               = var.storage_profile_enabled == null ? 0 : 1
#   name                = "${local.names.aks}-pe"
#   resource_group_name = data.azurerm_resource_group.main.name
#   location            = data.azurerm_resource_group.main.location
#   subnet_id           = var.vnet_subnet_id

#   private_service_connection {
#     name                           = "${local.names.aks}-psc"
#     private_connection_resource_id = azurerm_storage_account.main[0].id
#     is_manual_connection           = false
#     subresource_names              = ["blob"]
#   }
# }

# # Create DNS A Record
# resource "azurerm_private_dns_a_record" "dns_a" {
#   count               = var.storage_profile_enabled == null ? 0 : 1
#   name                = "${local.names.aks}stg"
#   zone_name           = data.azurerm_private_dns_zone.main.name
#   resource_group_name = data.azurerm_resource_group.main.name
#   ttl                 = 300
#   records             = [azurerm_private_endpoint.main[0].private_service_connection.0.private_ip_address]
# }