---
page_title: "Provisioning Azure Spoke VNET as per Data Exfiltration Protection with Terraform"
---

[Reference documentation and blog](https://databricks.com/blog/2020/03/27/data-exfiltration-protection-with-azure-databricks.html)

# How to Deploy a Lakehouse Blueprint using Best Practices and Industry Helper Libraries

This guide uses the following variables in configurations:

- `location`: (Required) The location for the resources in this module
- `hub_vnet_name`: (Required) The name of the existing hub Virtual Network
- `hub_vnet_id` - (Required) The name of the existing hub Virtual Network
- `hub_resource_group_name` - (Required) The name of the existing Resource Group containing the hub Virtual Network
- `firewall_name` - (Required) The name of the Azure Firewall deployed in your hub Virtual Network
- `firewall_private_ip` - (Required) The hub firewall's private IP address
- `spoke_resource_group_name` - (Required) The name of the Resource Group to create
- `project_name` - (Required) The name of the project associated with the infrastructure to be managed by Terraform
- `spoke_vnet_address_space` - (Required) The address space for the spoke Virtual Network
- `scc_relay_address_prefixes` - (Required) The IP address(es) of the Databricks SCC relay (see https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/udr#control-plane-nat-and-webapp-ip-addresses)
- `privatelink_subnet_address_prefixes` - (Required) The address prefix(es) for the PrivateLink subnet
- `webapp_and_infra_routes` - (Required) Map of regional webapp and ext-infra CIDRs.
   Check https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/udr#ip-addresses for more info
   Ex., for eastus:
   {
     "webapp1" : "40.70.58.221/32",
     "webapp2" : "20.42.4.209/32",
     "webapp3" : "20.42.4.211/32",
     "ext-infra" : "20.57.106.0/28"
   }
- `public_repos` - (Required) List of public repository IP addresses to allow access to.
- `tags` - (Required) Map of tags to attach to resources

This guide is provided as-is and you can use this guide as the basis for your custom Terraform module. This module creates the Azure Spoke vnet as per the architecture in the Databricks [blog](https://databricks.com/blog/2020/03/27/data-exfiltration-protection-with-azure-databricks.html)

## Output Variables

- `rg_name` - Azure resource group for Spoke VNET
- `vnet_name` - VNET name
- `vnet_id` - VNET ID
- `nsg_id` - Network security ID
- `route_table_id` - Route table ID referenced in VNET injected workspace

## Provider initialization

Initialize [provider with `mws` alias](https://www.terraform.io/language/providers/configuration#alias-multiple-provider-configurations) to set up account-level resources.

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.13.0"
    }
  }
}

```
