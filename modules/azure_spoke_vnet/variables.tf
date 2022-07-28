variable "location" {
  type        = string
  description = "(Required) The location for the resources in this module"
}

variable "hub_vnet_name" {
  type        = string
  description = "(Required) The name of the existing hub Virtual Network"
}

variable "hub_vnet_id" {
  type        = string
  description = "(Required) The name of the existing hub Virtual Network"
}

variable "hub_resource_group_name" {
  type        = string
  description = "(Required) The name of the existing Resource Group containing the hub Virtual Network"
}

variable "firewall_name" {
  type        = string
  description = "(Required) The name of the Azure Firewall deployed in your hub Virtual Network"
}

variable "firewall_private_ip" {
  type        = string
  description = "(Required) The hub firewall's private IP address"
}

variable "spoke_resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group to create"
}

variable "project_name" {
  type        = string
  description = "(Required) The name of the project associated with the infrastructure to be managed by Terraform"
}

variable "spoke_vnet_address_space" {
  type        = string
  description = "(Required) The address space for the spoke Virtual Network"
}

variable "scc_relay_address_prefixes" {
  type        = list(string)
  description = "(Required) The IP address(es) of the Databricks SCC relay (see https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/udr#control-plane-nat-and-webapp-ip-addresses)"
}

variable "privatelink_subnet_address_prefixes" {
  type        = list(string)
  description = "(Required) The address prefix(es) for the PrivateLink subnet"
}

variable "webapp_and_infra_routes" {
  type        = map(string)
  description = <<EOT
   (Required) Map of regional webapp and ext-infra CIDRs.
   Check https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/udr#ip-addresses for more info
   Ex., for eastus:
   {
     "webapp1" : "40.70.58.221/32",
     "webapp2" : "20.42.4.209/32",
     "webapp3" : "20.42.4.211/32",
     "ext-infra" : "20.57.106.0/28"
   }
   EOT
}

variable "public_repos" {
  type        = list(string)
  description = "(Required) List of public repository IP addresses to allow access to."
}

variable "tags" {
  type        = map(string)
  description = "(Required) Map of tags to attach to resources"
}
