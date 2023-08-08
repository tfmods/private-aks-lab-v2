###
## DATASOURCES
###
data "azurerm_subscription" "main" {}
data "azuread_client_config" "main" {}
data "azurerm_client_config" "main" {}


# resource group onde o aks será deployado
data "azurerm_resource_group" "main" {
  provider = azurerm.main
  name     = var.aks_rg_name
  #  location = "eastus2"
}
##REVERT

# resource group onde o aks será deployado
data "azurerm_resource_group" "main_hlg" {
  provider = azurerm.main
  name     = var.aks_rg_name_hlg
  #  location = "eastus2"
}
data "azurerm_private_dns_zone" "main" {
  provider            = azurerm.tss
  name                = local.private_dns_zones.aks
  resource_group_name = data.azurerm_virtual_network.tss.resource_group_name
}


/* data "azurerm_resource_group" "links" {
  provider = azurerm.link
  name     = var.aks_network_dns_link_external_network
  #  location = "eastus2"
} */

# Aks identity
data "azurerm_user_assigned_identity" "aks" {
  provider            = azurerm.main
  name                = var.aks_managed_identity
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_user_assigned_identity" "aks_hlg" {
  provider            = azurerm.main
  name                = var.aks_managed_identity_hlg
  resource_group_name = data.azurerm_resource_group.main_hlg.name
}

# Get latest kubernetes Version
data "azurerm_kubernetes_service_versions" "main" {
  provider        = azurerm.main
  location        = data.azurerm_resource_group.main.location
  include_preview = "false"
}

#AKS_SUBNET
data "azurerm_subnet" "main" {
  provider             = azurerm.main
  name                 = var.aks_subnet
  virtual_network_name = var.aks_vnet
  resource_group_name  = var.aks_network_rg
}


data "azurerm_subnet" "main_hlg" {
  provider             = azurerm.main
  name                 = var.aks_subnet_hlg
  virtual_network_name = var.aks_vnet
  resource_group_name  = var.aks_network_rg
}

#TSS SUBNET
data "azurerm_subnet" "tss" {
  provider             = azurerm.tss
  name                 = var.kv_subnet
  virtual_network_name = var.kv_vnet
  resource_group_name  = var.kv_subnet_rg
}

#APPGW_SUBNET

data "azurerm_subnet" "appgw" {
  provider             = azurerm.main
  name                 = var.appgw_subnet
  virtual_network_name = var.appgw_vnet
  resource_group_name  = var.appgw_subnet_rg
}


data "azurerm_virtual_network" "main" {
  provider            = azurerm.main
  name                = var.aks_vnet
  resource_group_name = var.aks_network_rg
}

data "azurerm_virtual_network" "tss" {
  provider            = azurerm.tss
  name                = local.tss.network
  resource_group_name = local.tss.rg
}

data "azurerm_virtual_network" "tcn" {
  provider            = azurerm.tcn
  name                = local.tcn.network
  resource_group_name = local.tcn.rg
}

###### Zona Privada do AKS
/* resource "azurerm_private_dns_zone" "aks" {
  provider            = azurerm.tss
  name                = local.private_dns_zones.aks
  resource_group_name = data.azurerm_virtual_network.tss.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  #Link com rede do AKS
  provider              = azurerm.tss
  name                  = var.aks_network_dns_link
  resource_group_name   = data.azurerm_virtual_network.tss.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.main.name
  virtual_network_id    = data.azurerm_virtual_network.main.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "tss" {
  # Link com rede shared services 
  provider              = azurerm.tss
  name                  = var.aks_network_dns_link_tss
  resource_group_name   = data.azurerm_virtual_network.tss.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.main.name
  virtual_network_id    = data.azurerm_virtual_network.tss.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "tcn" {
  #link com terra conections
  provider              = azurerm.tss
  name                  = var.aks_network_dns_link_tcn
  resource_group_name   = data.azurerm_virtual_network.tss.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.main.name
  virtual_network_id    = data.azurerm_virtual_network.tcn.id
} */


module "aks_hlg" {
  providers                      = { azurerm = azurerm.main }
  source                         = "./modules/terraform-azurerm-aks"
  aks_name                       = data.azurerm_user_assigned_identity.aks_hlg.name
  azurerm_user_assigned_identity = data.azurerm_user_assigned_identity.aks_hlg.id
  resource_group_name            = data.azurerm_resource_group.main_hlg.name
  enable_azurerm_key_vault       = false
  azurerm_private_dns_zone_name  = data.azurerm_private_dns_zone.main.name
  private_dns_zone_id            = data.azurerm_private_dns_zone.main.id
  #gateway_id = "/subscriptions/f08b1fe3-f4f7-4c0a-bb51-d6a47cf1a81c/resourceGroups/rg-tbd-appgw-eastus2-01/providers/Microsoft.Network/applicationGateways/appgw-tbd-eastus2-01"
  private_cluster_enabled = true
  #gateway_id = azurerm_application_gateway.appgw.id
  # If aks ne
  #Storage Profile deployment
  storage_profile_enabled                     = true
  storage_profile_blob_driver_enabled         = true
  storage_profile_disk_driver_enabled         = true
  storage_profile_file_driver_enabled         = true
  storage_profile_snapshot_controller_enabled = true
  proxy_url                                   = var.proxy_url
  no_proxy                                    = var.no_proxy
  availability_zones                          = ["1", ]
  enable_auto_scaling                         = "true"
  max_pods                                    = 100
  #  orchestrator_version = data.azurerm_kubernetes_service_versions.aks.latest_version

  orchestrator_version = "1.26.3" # Current Default Version
  vnet_subnet_id       = data.azurerm_subnet.main_hlg.id
  vnet_id              = data.azurerm_virtual_network.main.id
  max_count            = 3
  min_count            = 1
  node_count           = 1
  #enable_log_analytics_workspace = true
  network_plugin    = "kubenet"
  network_policy    = "calico"
  load_balancer_sku = "standard"
  outbound_type     = var.outbound_type

  only_critical_addons_enabled = false


  node_pools = [
    {
      name                 = "akshlgnp001"
      availability_zones   = ["1", "2", "3"]
      enable_auto_scaling  = true
      max_pods             = 250
      orchestrator_version = "1.26.3"
      priority             = "Regular"
      max_count            = 5
      min_count            = 3
      node_count           = 5
      vm_size              = "Standard_D4s_v3"
  }]

  tags = {
    "ManagedBy"   = "Terraform"
    "idorcamento" = "ID000006"
    "ManagedBy" = "Terraform"
    "invent" = "aks-hlg"
  }

  depends_on = [
    #azurerm_application_gateway.appgw,
    data.azurerm_private_dns_zone.main,
    data.azurerm_user_assigned_identity.aks,
    data.azurerm_resource_group.main,
    data.azurerm_subnet.main,
  ]
}




#########
module "aks_dsv" {
  providers                      = { azurerm = azurerm.main }
  source                         = "./modules/terraform-azurerm-aks"
  aks_name                       = data.azurerm_user_assigned_identity.aks.name
  azurerm_user_assigned_identity = data.azurerm_user_assigned_identity.aks.id
  resource_group_name            = data.azurerm_resource_group.main.name
  enable_azurerm_key_vault       = false
  azurerm_private_dns_zone_name  = data.azurerm_private_dns_zone.main.name
  private_dns_zone_id            = data.azurerm_private_dns_zone.main.id
  #gateway_id = "/subscriptions/f08b1fe3-f4f7-4c0a-bb51-d6a47cf1a81c/resourceGroups/rg-tbd-appgw-eastus2-01/providers/Microsoft.Network/applicationGateways/appgw-tbd-eastus2-01"
  private_cluster_enabled = true
  #gateway_id = azurerm_application_gateway.appgw.id
  # If aks ne
  #Storage Profile deployment
  storage_profile_enabled                     = true
  storage_profile_blob_driver_enabled         = true
  storage_profile_disk_driver_enabled         = true
  storage_profile_file_driver_enabled         = true
  storage_profile_snapshot_controller_enabled = true
  proxy_url                                   = var.proxy_url
  no_proxy                                    = var.no_proxy
  availability_zones                          = ["1", ]
  enable_auto_scaling                         = "true"
  max_pods                                    = 100
  #  orchestrator_version = data.azurerm_kubernetes_service_versions.aks.latest_version

  orchestrator_version = "1.26.3" # Current Default Version
  vnet_subnet_id       = data.azurerm_subnet.main.id
  vnet_id              = data.azurerm_virtual_network.main.id
  max_count            = 3
  min_count            = 1
  node_count           = 1
  #enable_log_analytics_workspace = true
  network_plugin    = "kubenet"
  network_policy    = "calico"
  load_balancer_sku = "standard"
  outbound_type     = var.outbound_type

  only_critical_addons_enabled = false


  tags = {
    "ManagedBy" = "Terraform"
  }

  depends_on = [
    #azurerm_application_gateway.appgw,
    /* azurerm_private_dns_zone_virtual_network_link.main,
    azurerm_private_dns_zone_virtual_network_link.tss,
    azurerm_private_dns_zone_virtual_network_link.tcn, */
    data.azurerm_private_dns_zone.main,
    data.azurerm_user_assigned_identity.aks,
    data.azurerm_resource_group.main,
    data.azurerm_subnet.main,
  ]
}

######### AKS_PRD

module "aks_prd" {
  providers                      = { azurerm = azurerm.main }
  source                         = "./modules/terraform-azurerm-aks"
  aks_name                       = data.azurerm_user_assigned_identity.aks.name
  azurerm_user_assigned_identity = data.azurerm_user_assigned_identity.aks.id
  resource_group_name            = data.azurerm_resource_group.main.name
  enable_azurerm_key_vault       = false
  azurerm_private_dns_zone_name  = data.azurerm_private_dns_zone.main.name
  private_dns_zone_id            = data.azurerm_private_dns_zone.main.id
  #gateway_id = "/subscriptions/f08b1fe3-f4f7-4c0a-bb51-d6a47cf1a81c/resourceGroups/rg-tbd-appgw-eastus2-01/providers/Microsoft.Network/applicationGateways/appgw-tbd-eastus2-01"
  private_cluster_enabled = true
  #gateway_id = azurerm_application_gateway.appgw.id
  # If aks ne
  #Storage Profile deployment
  storage_profile_enabled                     = true
  storage_profile_blob_driver_enabled         = true
  storage_profile_disk_driver_enabled         = true
  storage_profile_file_driver_enabled         = true
  storage_profile_snapshot_controller_enabled = true
  proxy_url                                   = var.proxy_url
  no_proxy                                    = var.no_proxy
  availability_zones                          = ["1"]
  enable_auto_scaling                         = "true"
  max_pods                                    = 100
  #  orchestrator_version = data.azurerm_kubernetes_service_versions.aks.latest_version

  orchestrator_version = "1.26.3" # Current Default Version
  vnet_subnet_id       = data.azurerm_subnet.main.id
  vnet_id              = data.azurerm_virtual_network.main.id
  max_count            = 3
  min_count            = 1
  node_count           = 1
  #enable_log_analytics_workspace = true
  network_plugin    = "kubenet"
  network_policy    = "calico"
  load_balancer_sku = "standard"
  outbound_type     = var.outbound_type

  only_critical_addons_enabled = false


  tags = {
    "ManagedBy" = "Terraform"
  }

  depends_on = [
    #azurerm_application_gateway.appgw,
    /* azurerm_private_dns_zone_virtual_network_link.main,
    azurerm_private_dns_zone_virtual_network_link.tss,
    azurerm_private_dns_zone_virtual_network_link.tcn, */
    data.azurerm_private_dns_zone.main,
    data.azurerm_user_assigned_identity.aks,
    data.azurerm_resource_group.main,
    data.azurerm_subnet.main,
  ]
}

/* resource "azurerm_public_ip" "appgw" {
  name                = "${var.appgw_name}-pip"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_application_gateway" "appgw" {
  name                =  var.appgw_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "${var.appgw_name}-ip-configuration"
    subnet_id = data.azurerm_subnet.appgw.id
  }

  frontend_port {
    name = local.frontend_port_name_http
    port = 80
  }
  
  frontend_port {
    name = local.frontend_port_name_https
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}-http"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}-https"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name_http
    protocol                       = "Http"
  }

    http_listener {
    name                           = local.listener_name_s
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name_https
    protocol                       = "Https"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority = "10000"
  }

  waf_configuration {
    enabled = true
    firewall_mode = "Prevention"
    rule_set_version = "3.2"
  }

} */



/* resource "null_resource" "lazy-appgw" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash"]
    working_dir = path.module
    command     = <<EOT
    "az account set -s Terra-Brasil-Dev"
    "az network public-ip create -n $pip_name -g $app_gw_rg -l $location --allocation-method Static --sku Standard"
    "az network application-gateway waf-policy create --name $waf_policy_name --resource-group $app_gw_rg"
    "az network application-gateway create -n $appgw_name -l $location -g $app_gw_rg --sku WAF_v2 --public-ip-address $pip_name --vnet-name $appgw_vnet_name --subnet $appgw_snet_name --priority 100 --waf-policy $waf_policy_name"
    "appgwId=$(az network application-gateway show -n $appgw_name -g $app_gw_rg -o tsv --query "id")"
    "az aks enable-addons -n $aksName -g $app_gw_rg -a ingress-appgw --appgw-id $appgwId"
    "az aks enable-addons -n $aks_name -g $app_gw_rg -a ingress-appgw --appgw-id $appgwId"
    "az aks enable-addons -n $aks_name -g $aks_rg_name -a ingress-appgw --appgw-id $appgwId"
    EOT

    environment = {
      app_gw_rg       = "${var.aks_network_rg}"
      aks_name        = "${var.aks_managed_identity}"
      pip_name        = "dev-tbd-appgw-pip-eastus2-01"
      appgw_vnet_name = "${var.aks_vnet}"
      appgw_snet_name = "AppGw"
      location        = "eastus2"
      appgw_name      = "dev-appgw-tbd-eastus2-01"
      waf_policy_name = "dev-waf-policy-tbd-eastus2-01"
      aks_rg_name     = "${var.aks_rg_name}"

    }
  }
} */


/* resource "null_resource" "xpto" {
  # ...
  interpreter = ["/bin/bash", "-C"]
  provisioner "local-exec" {
    command = ""
  environment = {
 
    }
  }
  
} */
/* 
locals {
  # Define the path to the directory containing your Terraform files
  base_dir = path.cwd
}

data "template_file" "init" {
  template = file("${path.module}/proxy.sh")
  vars = {
    AKS = "${var.aks_managed_identity}"
    RG  = "${var.aks_rg_name}"
  }
}

resource "null_resource" "proxy_tf" {

  triggers = {
    template = "${data.template_file.init.rendered}"
  }


  provisioner "local-exec" {
    command = <<EOF
                ${data.template_file.init.rendered}
                EOF
  }

  depends_on = [
    module.aks,
  ]
} */