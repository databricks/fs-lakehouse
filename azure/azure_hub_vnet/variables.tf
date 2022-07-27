variable "location" {
  type        = string
  description = "(Required) The location for all shared infrastructure resources."
}

variable "hub_vnet_name" {
  type        = string
  description = "(Optional) The name of the hub virtual network."
  default     = "hub-vnet"
}
variable "hub_vnet_address_space" {
  type        = string
  description = "(Optional) The address spapce for the hub virtual network"
  default     = "10.3.1.0/24"
}

variable "hub_resource_group_name" {
  type        = string
  description = "(Optional) The name of the resource group for hub resources."
  default     = "hub-rg"
}

variable "firewall_subnet_address_prefixes" {
  type        = string
  description = "(Optional) The address prefixes for the Azure firewall subnet"
  default     = "10.3.1.0/26"
}
