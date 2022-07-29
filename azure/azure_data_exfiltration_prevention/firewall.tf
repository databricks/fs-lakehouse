locals {
  title_cased_location = title(var.location)
  service_tags = {
    "databricks" : { "tag" : "AzureDatabricks", "port" : "443" },
    "sql" : { "tag" : "Sql.${local.title_cased_location}", "port" : "3306" },
    "storage" : { "tag" : "Storage.${local.title_cased_location}", "port" : "443" },
    "eventhub" : { "tag" : "EventHub.${local.title_cased_location}", "port" : "9093" }
  }
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
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

resource "azurerm_firewall_policy" "this" {
  name                = "databricks-fwpolicy"
  resource_group_name = var.hub_resource_group_name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  name               = "databricks-fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 200
  application_rule_collection {
    name     = "databricks-app-rc"
    priority = 200
    action   = "Allow"

    rule {
      name             = "public-repos"
      source_addresses = ["*"]
      destination_fqdns = var.public_repos
      protocols {
        port = "443"
        type = "Https"
      }
      protocols {
        port = "80"
        type = "Http"
      }
    }

    rule {
      name             = "IPinfo"
      source_addresses = ["*"]
      destination_fqdns = ["cdnjs.com", "cdnjs.cloudflare.com"]
      protocols {
        port = "443"
        type = "Https"
      }
      protocols {
        port = "8080"
        type = "Http"
      }
      protocols {
        port = "80"
        type = "Http"
      }
    }

    rule {
      name              = "ganglia-ui"
      source_addresses  = ["*"]
      destination_fqdns = ["cdnjs.com", "cdnjs.cloudflare.com"]
      protocols {
        port = "443"
        type = "Https"
      }
    }
  }

  network_rule_collection {
    name     = "databricks-network-rc"
    priority = 100
    action   = "Allow"

    dynamic "rule" {
      for_each = var.webapp_and_infra_routes
      content {
        name                  = rule.key
        source_addresses      = ["*"]
        destination_ports     = ["443"]
        destination_addresses = [rule.value]
        protocols             = ["TCP"]
      }
    }

    dynamic "rule" {
      for_each = local.service_tags
      content {
        name                  = rule.key
        source_addresses      = ["*"]
        destination_addresses = [rule.value.tag]
        destination_ports     = [rule.value.port]
        protocols             = ["TCP"]
      }
    }
  }
}

resource "azurerm_firewall" "this" {
  name                = "${azurerm_virtual_network.this.name}-firewall"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.this.id

  ip_configuration {
    name                 = "firewall-public-ip-config"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.this.id
  }
}
