data "azurerm_virtual_network" "hub_vnet" {
  name                = var.hub_vnet_name
  resource_group_name = var.hub_resource_group_name
}

data "azurerm_firewall" "this" {
  name                = var.hub_firewall_name
  resource_group_name = var.hub_resource_group_name
}

locals {
  title_cased_location = title(data.azurerm_virtual_network.hub_vnet.location)
}
resource "azurerm_resource_group" "this" {
  name     = var.spoke_resource_group_name
  location = data.azurerm_virtual_network.hub_vnet.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "spoke-vnet-${var.project_name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.spoke_vnet_address_space]
  tags                = var.tags
}

resource "azurerm_virtual_network_peering" "this" {
  name                      = format("from-%s-to-%s-peer", azurerm_virtual_network.this.name, data.azurerm_virtual_network.hub_vnet.name)
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = data.azurerm_virtual_network.hub_vnet.id
}

resource "azurerm_network_security_group" "this" {
  name                = "databricks-nsg-${var.project_name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

resource "azurerm_route_table" "this" {
  name                = "route-table-${var.project_name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

resource "azurerm_route" "firewall_route" {
  name                   = "to-firewall"
  resource_group_name    = azurerm_resource_group.this.name
  route_table_name       = azurerm_route_table.this.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = data.azurerm_firewall.this.ip_configuration[0].private_ip_address
}

resource "azurerm_route" "scc_routes" {
  count               = length(var.scc_relay_address_prefixes)
  name                = "to-${azurerm_resource_group.this.location}-SCC-relay-ip-${count.index})"
  resource_group_name = azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.this.name
  address_prefix      = var.scc_relay_address_prefixes[count.index]
  next_hop_type       = "Internet"
}

module "databricks_workspace" {
  source                          = "../modules/azure-vnet-injected-databricks-workspace"
  workspace_name                  = var.workspace_name
  databricks_resource_group_name  = azurerm_resource_group.this.name
  location                        = azurerm_virtual_network.this.location
  vnet_id                         = azurerm_virtual_network.this.id
  vnet_name                       = azurerm_virtual_network.this.name
  nsg_id                          = azurerm_network_security_group.this.id
  route_table_id                  = azurerm_route_table.this.id
  private_subnet_address_prefixes = var.private_subnet_address_prefixes
  public_subnet_address_prefixes  = var.public_subnet_address_prefixes
  tags                            = var.tags
}

resource "azurerm_firewall_application_rule_collection" "this" {
  name                = "Databricks-${var.workspace_name}"
  azure_firewall_name = data.azurerm_firewall.this.name
  resource_group_name = var.hub_resource_group_name
  priority            = 200
  action              = "Allow"

  rule {
    name = "public-repos"
    source_addresses = concat(
      var.public_subnet_address_prefixes,
      var.private_subnet_address_prefixes
    )
    target_fqdns = var.public_repos
    protocol {
      port = "443"
      type = "Https"
    }
    protocol {
      port = "80"
      type = "Http"
    }
  }

  rule {
    name = "IPinfo"
    source_addresses = concat(
      var.public_subnet_address_prefixes,
      var.private_subnet_address_prefixes
    )
    target_fqdns = ["*.ipinfo.io"]
    protocol {
      port = "443"
      type = "Https"
    }
    protocol {
      port = "8080"
      type = "Http"
    }
    protocol {
      port = "80"
      type = "Http"
    }
  }

  rule {
    name = "ganglia-ui"
    source_addresses = concat(
      var.public_subnet_address_prefixes,
      var.private_subnet_address_prefixes
    )
    target_fqdns = ["cdnjs.com", "cdnjs.cloudflare.com"]
    protocol {
      port = "443"
      type = "Https"
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "this" {
  name                = "Databricks-${var.workspace_name}"
  azure_firewall_name = data.azurerm_firewall.this.name
  resource_group_name = var.hub_resource_group_name
  priority            = 200
  action              = "Allow"

  rule {
    name = "webapp-and-ext-infra"
    source_addresses = concat(
      var.public_subnet_address_prefixes,
      var.private_subnet_address_prefixes
    )
    destination_ports     = ["443"]
    destination_addresses = var.webapp_and_infra_routes
    protocols             = ["TCP"]
  }

  rule {
    name = "db-control-plane-service-tags"
    source_addresses = concat(
      var.public_subnet_address_prefixes,
      var.private_subnet_address_prefixes
    )
    destination_addresses = [
      "AzureDatabricks",
      "Sql.${local.title_cased_location}",
      "Storage.${local.title_cased_location}",
      "EventHub.${local.title_cased_location}"
    ]
    destination_ports = ["443", "9093", "3306"]
    protocols         = ["TCP", "UDP"]

  }
}
