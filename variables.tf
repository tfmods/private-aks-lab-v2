variable "location" {
  description = "The resource group location"
  default     = "eastus"
}

variable "vnet_resource_group_name" {
  description = "The resource group name to be created"
  default     = "networks"
}

variable "hub_vnet_name" {
  description = "Hub VNET name"
  default     = "hub1-firewalvnet"
}

variable "kube_vnet_name" {
  description = "AKS VNET name"
  default     = "spoke1-kubevnet"
}

variable "kube_version_prefix" {
  description = "AKS Kubernetes version prefix. Formatted '[Major].[Minor]' like '1.18'. Patch version part (as in '[Major].[Minor].[Patch]') will be set to latest automatically."
  default     = "1.18"
}

variable "kube_resource_group_name" {
  description = "The resource group name to be created"
  default     = "nopublicipaks"
}

variable "nodepool_nodes_count" {
  description = "Default nodepool nodes count"
  default     = 1
}

variable "nodepool_vm_size" {
  description = "Default nodepool VM size"
  default     = "Standard_B2s"
}

variable "network_docker_bridge_cidr" {
  description = "CNI Docker bridge cidr"
  default     = "172.17.0.1/16"
}

variable "network_dns_service_ip" {
  description = "CNI DNS service IP"
  default     = "10.2.0.10"
}

variable "network_service_cidr" {
  description = "CNI service cidr"
  default     = "10.2.0.0/24"
}


/* variable "object_id" {
  default = "3afdbb27-fcc9-45a1-bca0-fcb6028386a0"

}

variable "client_id" {
  default = "68649dd6-a108-4299-a8b9-200f3e69d06b"
}

variable "client_secret" {
  default = "Wqm8Q~G2~kovVloBrAtg1JmzbfYUIb-MjZpqTa-9"
}
<<<<<<< HEAD
} */

variable "outbound_type" {
  description = <<EOT
The outbound (egress) routing method which should be used for this Kubernetes
Cluster. Possible values are loadBalancer and userDefinedRouting.
EOT
  type        = string
  default     = "userDefinedRouting"
}


variable "aks_azurerm_private_dns_zone" {
  description = "Zona privada de dns criada para suportar segredos do aks"
  default     = "privatelink.eastus2.azmk8s.io"
}

variable "kv_azurerm_private_dns_zone" {
  description = "Zona privada de dns criada para suportar api server do aks"
  default     = "privatelink.eastus2.azmk8s.io"
}

variable "aks_network_dns_link" {
  default     = "aks-dns-network-link"
  description = "nome do link de dns criado para conectar ao api server"
}

variable "aks_managed_identity" {
  default     = {}
  description = "identidade gerenciada para aks - deve ser solicitado ao time de segurança"

}

variable "aks_subnet" {
  default     = null
  description = "subnet para deploy de aks privado -  datasource de uma rede criada no azure"
}

variable "aks_vnet" {
  description = "Subnet onde"
}

variable "aks_rg_name" {
  description = "Nome do rg onde o aks será deployado"
}

variable "aks_network_rg" {
  description = "rg onde esta a rede do aks"
}

variable "aks_network_dns_link_tss" {
  description = "Rede do ambiente terra shared services linkada com dns privado do aks para resolução via azure dns resolver."
}


variable "aks_network_dns_link_tcn" {
  description = "Rede do ambiente terra shared services linkada com dns privado do aks para resolução via azure dns resolver."
}

variable "main_subscription_id" {
  description = "Subscription onde os recursos serão deployados"
}

variable "tss_subscription_id" {
  description = "Subscription onde estão os Private Links   -Terra shared services"
}

variable "tcn_subscription_id" {
  description = "Subscription onde estão os Private Links   -Terra shared services"
}


variable "proxy_url" {
  description = "Proxy url"
}

variable "no_proxy" {
  description = "endereços que não passam pelo proxy"
}

variable "kv_name" {
  description = "Nome do azure key vault criado"
}

variable "acr_name" {
  description = "Nome do azure key vault criado"
}

variable "acr_sku" {
  description = "Nome do azure key vault criado"
}

/* variable "tags" {

} */

variable "kv_subnet" {

}

variable "kv_vnet" {

}

variable "kv_subnet_rg" {

}

variable "acr_rg_name" {

}