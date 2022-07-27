resource "azurerm_resource_group" "this" {
  name     = var.hub_resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "this" {
  name          = var.hub_vnet_name
  location      = azurerm_resource_group.this.location
  address_space = [var.hub_vnet_address_space]
}

resource "azurerm_subnet" "this" {
  name                 = "firewall-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = [var.firewall_subnet_address_prefixes]
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.AzureActiveDirectory"
  ]
}

resource "azurerm_public_ip" "this" {
  name                = "firewall-public-ip"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "this" {
  name                = "firewall-${azurerm_virtual_network.this.name})"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "firewall-public-ip-config"
    subnet_id            = azurerm_subnet.this.id
    public_ip_address_id = azurerm_public_ip.this.id
  }
}
