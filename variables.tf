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
  default     = "Standard_D2_v2"
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
} */

variable "outbound_type" {
  description = <<EOT
The outbound (egress) routing method which should be used for this Kubernetes
Cluster. Possible values are loadBalancer and userDefinedRouting.
EOT
  type        = string
  default     = "userDefinedRouting"
}