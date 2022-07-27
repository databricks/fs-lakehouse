variable "hub_vnet_name" {
  type        = string
  description = "(Required) The name of the existing hub Virtual Network"
}
variable "hub_resource_group_name" {
  type        = string
  description = "(Required) The name of the existing Resource Group containing the hub Virtual Network"
}
variable "hub_firewall_name" {
  type        = string
  description = "(Required) The name of the Azure Firewall deployed in your hub Virtual Network"
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
  description = "(Optional) The address space for the spoke Virtual Network"
  default     = "10.2.1.0/24"
}
variable "scc_relay_address_prefixes" {
  type        = list(string)
  description = "(Required) The IP address(es) of the Databricks SCC relay (see https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/udr#control-plane-nat-and-webapp-ip-addresses)"
}
variable "workspace_name" {
  type        = string
  description = "(Required) The name of the Databricks Workspace to create in the spoke Virtual Network"
}
variable "private_subnet_address_prefixes" {
  type        = string
  description = "(Optional) The address prefix for the Databricks private subnet"
  default     = "10.2.1.128/26"
}
variable "public_subnet_address_prefixes" {
  type        = string
  description = "(Optional) The address prefix for the Databricks public subnet"
  default     = "10.2.1.64/26"
}
variable "ext_infra_routes" {
  type = map
  description = "(Required)"
}
variable "webapp_and_infra_routes" {
   type        = list(string) 
   description = <<EOT
   (Required) List of regional webapp and ext-infra CIDRs.
   Check https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/udr#ip-addresses for more info
   Ex., for eastus:
   [
     "40.70.58.221/32",
     "20.42.4.209/32",
     "20.42.4.211/32",
     "20.57.106.0/28"
   ]
   EOT
}
variable "public_repos" {
  type = list(string)
  description = "(Optional) List of public repository IP addresses to allow access to."
  default = ["*.pypi.org", "*pythonhosted.org", "cran.r-project.org"]
}
variable "tags" {
  type        = map(string)
  description = "(Optional) Map of tags to attach to resources"
  default     = {}
}
