terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.43.0"
    }
  }
  /* backend "azurerm" {
    resource_group_name  = "tfstatelabs001"
    storage_account_name = "tfstatelabs001"
    container_name       = "tfstate001"
    key                  = "terraformv2.tfstate"
  } */
}
provider "azurerm" {
  //outbound_type https://github.com/terraform-providers/terraform-provider-azurerm/blob/v2.5.0/CHANGELOG.md
  features {}
}

data "azurerm_subscription" "main" {}

/* resource "azurerm_resource_group" "vnet" {
  name     = var.vnet_resource_group_name
  location = var.location
}

resource "azurerm_resource_group" "kube" {
  name     = var.kube_resource_group_name
  location = var.location
} */
/* 
module "hub_network" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.vnet.name
  location            = var.location
  vnet_name           = var.hub_vnet_name
  address_space       = ["10.0.0.0/16"]
  subnets = [
    {
      name : "AzureFirewallSubnet"
      address_prefixes : ["10.0.0.0/24"]
    },
    {
      name : "jumpbox-subnet"
      address_prefixes : ["10.0.1.0/24"]
    },
    {
      name : "app-gw-subnet"
      address_prefixes : ["10.0.2.0/24"]
    }
  ]
}

module "kube_network" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.kube.name
  location            = var.location
  vnet_name           = var.kube_vnet_name
  address_space       = ["10.100.0.0/16"]
  subnets = [
    {
      name : "aks-subnet"
      address_prefixes : ["10.100.1.0/24"]
    },
    {
      name : "private-ingress-subnet"
      address_prefixes : ["10.100.2.0/24"]
    },
  ]
}

module "vnet_peering" {
  source              = "./modules/vnet_peering"
  vnet_1_name         = var.hub_vnet_name
  vnet_1_id           = module.hub_network.vnet_id
  vnet_1_rg           = azurerm_resource_group.vnet.name
  vnet_2_name         = var.kube_vnet_name
  vnet_2_id           = module.kube_network.vnet_id
  vnet_2_rg           = azurerm_resource_group.kube.name
  peering_name_1_to_2 = "HubToSpoke1"
  peering_name_2_to_1 = "Spoke1ToHub"
}

module "firewall" {
  source         = "./modules/firewall"
  resource_group = azurerm_resource_group.vnet.name
  location       = var.location
  pip_name       = "azureFirewalls-ip"
  fw_name        = "kubenetfw"
  subnet_id      = module.hub_network.subnet_ids["AzureFirewallSubnet"]
} */
/* 
module "routetable" {
  source             = "./modules/route_table"
  resource_group     = azurerm_resource_group.vnet.name
  location           = var.location
  rt_name            = "kubenetfw_fw_rt"
  r_name             = "kubenetfw_fw_r"
  firewal_private_ip = module.firewall.fw_private_ip
  subnet_id          = module.kube_network.subnet_ids["aks-subnet"]
} */






/* resource "azurerm_role_assignment" "kube" {
  scope                = azurerm_resource_group.kube.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}
resource "azurerm_role_assignment" "network" {
  scope                = azurerm_resource_group.vnet.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}  


resource "azurerm_role_assignment" "dns" {
  scope                = azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
} 
*/

/* #az aks admin from AAD
data "azuread_user" "aad" {
  #how to find the user ID
  #az ad user show --id xpto@xarope.com on azure cli (bash ) or azure cloud shell
  object_id = var.object_id
} */


## DATASOURCES
data "azurerm_resource_group" "main" {
  name = "rg-dsv-aks"
  #  location = "eastus2"
}

resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.eastus2.azmk8s.io"
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = "aks-dns-link"
  resource_group_name   = data.azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = data.azurerm_virtual_network.main.id
}


# Aks identity
data "azurerm_user_assigned_identity" "aks" {
  name                = "aks-dev-tbd-eastus2-01"
  resource_group_name = data.azurerm_resource_group.main.name
}

# Get latest kubernetes Version
data "azurerm_kubernetes_service_versions" "main" {
  location        = data.azurerm_resource_group.main.location
  include_preview = false
}

data "azurerm_subnet" "main" {
  name                 = "snet-tbd-eastus2-005"
  virtual_network_name = "vn-tbd-eastus2"
  resource_group_name  = "rg-network-tbd-eastus2-01"
}



data "azurerm_virtual_network" "main" {
  name                = "vn-tbd-eastus2"
  resource_group_name = "rg-network-tbd-eastus2-01"
}

### Linked networks
/* data "azurerm_virtual_network" "vn-tcn-br-eastus2" {
  name                = "vn-tcn-br-eastus2"
  resource_group_name = "rg-network-tcn-br-eastus2-01"
}

data "azurerm_virtual_network" "vn-tss-eastus2" {
  name                = "vn-tss-eastus2"
  resource_group_name = "rg-network-tss-eastus2-01"
} */


#########
module "aks" {
  source = "./modules/terraform-azurerm-aks"
  # prefixo de nome do aks
  aks_name                 = data.azurerm_user_assigned_identity.aks.name
  azurerm_user_assigned_identity = data.azurerm_user_assigned_identity.aks.id
  resource_group_name      = data.azurerm_resource_group.main.name
  enable_azurerm_key_vault = false
  #dns_prefix          = data.azurerm_user_assigned_identity.aks.name
  #user_assigned_identity_id          = azurerm_user_assigned_identity.aks.id
  #aad_aks_group_ownners              = ["rosthan.silva@swonelab.com"]
  #enable_azure_active_directory      = true
  #rbac_aad_managed                   = true
  #key_vault_secrets_provider_enabled = true
  #rbac_aad_admin_group_object_ids = [azuread_group.aks.object_id]
  azurerm_private_dns_zone_name = azurerm_private_dns_zone.aks.name
  private_dns_zone_id           = azurerm_private_dns_zone.aks.id
 
#  azurerm_private_dns_zone_name = azurerm_private_dns_zone.aks.name
#  private_dns_zone_id           = azurerm_private_dns_zone.aks.id
  private_cluster_enabled       = true
  #public_ssh_key = "~/.ssh/id_rsa.pub"
/* >>>>>>> 6c8a56e (telefonica) */

  # Service Principal for aks 
  /* client_id     = var.client_id
  client_secret = var.client_secret */

  # If aks ne
  #Storage Profile deployment
  storage_profile_enabled                     = true
  storage_profile_blob_driver_enabled         = true
  storage_profile_disk_driver_enabled         = true
  storage_profile_file_driver_enabled         = true
  storage_profile_snapshot_controller_enabled = true

  availability_zones  = ["1",]
  enable_auto_scaling = "true"
  max_pods            = 100
  #  orchestrator_version = data.azurerm_kubernetes_service_versions.aks.latest_version
  orchestrator_version = "1.24.9" # Current Default Version
  vnet_subnet_id       = data.azurerm_subnet.main.id
  vnet_id              = data.azurerm_virtual_network.main.id
  #hub_vnet_id          = module.hub_network.vnet_id
  max_count  = 3
  min_count  = 1
  node_count = 1

  #enable_log_analytics_workspace = true

  network_plugin    = "kubenet"
  network_policy    = "calico"
  load_balancer_sku = "standard"
  outbound_type     = var.outbound_type
  
  only_critical_addons_enabled = false

  # node_pools = [
  #   {
  #     name                 = "np001"
  #     availability_zones   = ["1", "2", "3"]
  #     enable_auto_scaling  = true
  #     max_pods             = 100
  #     orchestrator_version = "1.24.9"
  #     priority             = "Regular"
  #     max_count            = 3
  #     min_count            = 1
  #     node_count           = 1
  #   },
  #   {
  #     name                 = "npspot001"
  #     enable_auto_scaling  = true
  #     max_pods             = 100
  #     orchestrator_version = "1.24.9"
  #     priority             = "Spot"
  #     eviction_policy      = "Delete"
  #     spot_max_price       = 0.5
  #     max_count            = 3
  #     min_count            = 1
  #     node_count           = 1
  #     # note: this is the "maximum" price
  #     node_labels = {
  #       "kubernetes.azure.com/scalesetpriority" = "spot"
  #     }
  #     node_taints = [
  #       "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  #     ]
  #     node_count = 1
  #   }
  # ]

  tags = {
    "ManagedBy" = "Terraform"
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.main,
    azurerm_private_dns_zone.aks,
    data.azurerm_user_assigned_identity.aks,
    data.azurerm_resource_group.main,
    data.azurerm_subnet.main,

  ]
}


# resource "azurerm_kubernetes_cluster" "privateaks" {
#   name                    = "private-aks"
#   location                = var.location
#   kubernetes_version      = data.azurerm_kubernetes_service_versions.current.latest_version
#   resource_group_name     = azurerm_resource_group.kube.name
#   dns_prefix              = "private-aks"
#   private_cluster_enabled = true

#   default_node_pool {
#     name           = "default"
#     node_count     = var.nodepool_nodes_count
#     vm_size        = var.nodepool_vm_size
#     vnet_subnet_id = module.kube_network.subnet_ids["aks-subnet"]
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   network_profile {
#     docker_bridge_cidr = var.network_docker_bridge_cidr
#     dns_service_ip     = var.network_dns_service_ip
#     network_plugin     = "azure"
#     outbound_type      = "userDefinedRouting"
#     service_cidr       = var.network_service_cidr
#   }

#   depends_on = [module.routetable]
# }

# resource "azurerm_role_assignment" "netcontributor" {
#   role_definition_name = "Network Contributor"
#   scope                = module.kube_network.subnet_ids["aks-subnet"]
#   principal_id         = module.aks.aks_identity #azurerm_kubernetes_cluster.privateaks.identity[0].principal_id
# }

/* module "jumpbox" {
  source                  = "./modules/jumpbox"
  location                = var.location
  resource_group          = azurerm_resource_group.vnet.name
  vnet_id                 = module.hub_network.vnet_id
  subnet_id               = module.hub_network.subnet_ids["jumpbox-subnet"]
  dns_zone_name           = join(".", slice(split(".", module.aks.private_fqdns), 1, length(split(".", module.aks.private_fqdns))))
  dns_zone_resource_group = module.aks.node_resource_group

  depends_on = [
    module.aks
  ]
} */


/* ####     ===cC   
# Storage Account 
####     ===cC   
data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

module "storage_account" {
  # source is set to use local path for testing the latest version. 
  source = "./modules/terraform-azurerm-storage-account"
  #source  = "andrewCluey/storage-account/azurerm"
  #version = "3.0.0"

  storage_account_name = "aksstaxpto"

  location               = azurerm_resource_group.kube.location
  sa_resource_group_name = azurerm_resource_group.kube.name

  blob_containers = ["aks-blob1", "default"]
  #storage_queues         = []
  #storage_tables         = ["appTable", "devTable"]
  storage_shares    = ["nginx-configs", "aks-data-drive"]
  default_action    = "Deny"
  bypass_services   = [] # Try to avoid adding bypass services as this opens up access to ALL Azure customers.
  allowed_public_ip = [data.http.ip.response_body]
  # If default_action is set to `Deny`, ensure the public IP where Terraform runs from still has access.
  #allowed_subnet_ids = [azurerm_virtual_network.kubernetes-vnet.id]
} */
