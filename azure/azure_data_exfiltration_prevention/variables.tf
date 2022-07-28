variable "project_name" {
  type        = string
  description = "(Required) The name of the project associated with the infrastructure to be managed by Terraform"
}

variable "location" {
  type        = string
  description = "(Required) The location for the resources in this module"
}

variable "hub_resource_group_name" {
  type = string
  description = "(Optional) The name for the hub Resource Group"
  default = "hub-rg"
}

variable "hub_vnet_name" {
  type        = string
  description = "(Optional) The name for the hub Virtual Network"
  default = "hub-vnet"
}

variable "hub_vnet_address_space" {
  type = string
  description = "(Optional) The address space for the hub Virtual Network"
  default = "10.3.1.0/24"
}

variable "spoke_resource_group_name" {
  type        = string
  description = "(Optional) The name of the Resource Group to create"
  default = "spoke-rg"
}

variable "spoke_vnet_address_space" {
  type        = string
  description = "(Optional) The address space for the spoke Virtual Network"
  default     = "10.2.1.0/24"
}

variable "databricks_workspace_name" {
  type = string
  description = "(Required) The name of the Azure Databricks Workspace to deploy"
}

variable "scc_relay_address_prefixes" {
  type        = list(string)
  description = "(Required) The IP address(es) of the Databricks SCC relay (see https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/udr#control-plane-nat-and-webapp-ip-addresses)"
}

variable "privatelink_subnet_address_prefixes" {
  type        = list(string)
  description = "(Optional) The address prefix(es) for the PrivateLink subnet"
  default     = ["10.2.1.0/26"]
}

variable "private_subnet_address_prefixes" {
  type        = list(string)
  description = "(Optional) The address prefix(es) for the Databricks private subnet"
  default     = ["10.2.1.128/26"]
}

variable "public_subnet_address_prefixes" {
  type        = list(string)
  description = "(Optional) The address prefix(es) for the Databricks public subnet"
  default     = ["10.2.1.64/26"]
}

variable "firewall_subnet_address_prefixes" {
  type        = string
  description = "(Optional) The address prefixes for the Azure firewall subnet"
  default     = "10.3.1.0/26"
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
  description = "(Optional) List of public repository IP addresses to allow access to."
  default     = ["*.pypi.org", "*pythonhosted.org", "cran.r-project.org"]
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Map of tags to attach to resources"
  default     = {}
}
