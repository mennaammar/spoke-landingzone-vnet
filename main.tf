terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.75.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.4.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.0"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}

resource "random_string" "prefix" {
  count   = try(var.global_settings.prefix, null) == null ? 1 : 0
  length  = 4
  special = false
  upper   = false
  number  = false
}

provider "azurerm" {
  features {}
  # credentials here 

}
data "azurerm_client_config" "current" {}

# create resource group name. 
resource "azurecaf_name" "rg" {
  name          = var.resource_group_name
  resource_type = "azurerm_resource_group"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

module "resource_groups" {
  source   = "./modules/resource_group"
  name     = azurecaf_name.rg.result
  location = var.global_settings.regions[lookup(var.settings, "region", var.global_settings.default_region)]
  tags     = var.tags
}




module "networking" {
  depends_on = [module.network_watchers]
  source     = "./modules/networking/virtual_network"
  for_each   = var.networking.vnets



  client_config                     = data.azurerm_client_config.current.client_id
  name                              = each.value.vnet.name
  address_space                     = each.value.vnet.address_space
  dns_servers                       = each.value.vnet.dns_servers
  diagnostics                       = null
  global_settings                   = var.global_settings
  network_security_group_definition = var.networking.network_security_group_definition
  network_watchers                  = module.network_watchers
  route_tables                      = module.route_tables
  settings                          = each.value
  tags                              = try(each.value.tags, null)

  resource_group_name = module.resource_groups.name
  location            = module.resource_groups.location
  base_tags           = {}
  #application_security_groups       = local.combined_objects_application_security_groups
  #base_tags           = try(local.global_settings.inherit_tags, false) ? local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags : {}

  #ddos_id                           = try(azurerm_network_ddos_protection_plan.ddos_protection_plan[each.value.ddos_services_key].id, "")
  #diagnostics                       = local.combined_diagnostics

  #network_security_groups           = module.nsg
  #network_security_group_definition = local.networking.network_security_group_definition

  # network_security_group_definition = {}

  #   remote_dns = {
  #     azurerm_firewall = try(var.remote_objects.azurerm_firewall, null) #assumed from remote lz only
  #   }
}


resource "azurecaf_name" "peering" {

  name          = var.networking.vnet_peerings.name
  resource_type = "azurerm_virtual_network_peering"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

# The code tries to peer to a vnet created in the same landing zone. If it fails it tries with the data remote state
resource "azurerm_virtual_network_peering" "peering" {
  depends_on = [module.networking]

  for_each                  = module.networking
  name                      = azurecaf_name.peering.result
  virtual_network_name      = each.value.name
  resource_group_name       = each.value.resource_group_name
  remote_virtual_network_id = var.networking.vnet_peerings.remote_virtual_network_id

  allow_virtual_network_access = var.networking.vnet_peerings.allow_virtual_network_access
  allow_forwarded_traffic      = var.networking.vnet_peerings.allow_forwarded_traffic
  allow_gateway_transit        = var.networking.vnet_peerings.allow_gateway_transit
  use_remote_gateways          = var.networking.vnet_peerings.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "peering2" {
  depends_on = [module.networking]

  for_each                     = module.networking
  name                         = azurecaf_name.peering.result
  virtual_network_name         = var.networking.vnet_peerings.remote_virtual_network_name
  resource_group_name          = var.networking.vnet_peerings.remote_resource_group_name
  remote_virtual_network_id    = each.value.id
  allow_virtual_network_access = var.networking.vnet_peerings.allow_virtual_network_access
  allow_forwarded_traffic      = var.networking.vnet_peerings.allow_forwarded_traffic
  allow_gateway_transit        = var.networking.vnet_peerings.allow_gateway_transit
  use_remote_gateways          = var.networking.vnet_peerings.use_remote_gateways
}
module "network_watchers" {
  source              = "./modules/networking/network_watcher"
  resource_group_name = module.resource_groups.name
  location            = module.resource_groups.location
  base_tags           = null
  name                = "test"
  tags                = null
  global_settings     = var.global_settings
}

module "log_analytics" {
  source = "./modules/log_analytics"
  #for_each = var.log_analytics

  global_settings = var.global_settings
  resource_groups = module.resource_groups
  log_analytics   = var.log_analytics
  base_tags       = null
}

module "route_tables" {
  source                        = "./modules/networking/route_tables"
  name                          = "route_table"
  resource_group_name           = module.resource_groups.name
  location                      = module.resource_groups.location
  disable_bgp_route_propagation = false
  tags                          = null
  base_tags                     = null


}
resource "azurecaf_name" "routes" {
  for_each = var.networking.azurerm_routes

  name          = try(each.value.name, null)
  resource_type = "azurerm_route"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}


module "routes" {
  source   = "./modules/networking/routes"
  for_each = var.networking.azurerm_routes

  name                   = azurecaf_name.routes[each.key].result
  resource_group_name    = module.resource_groups.name
  route_table_name       = module.route_tables.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = try(lower(each.value.next_hop_type), null) == "virtualappliance" ? try(each.value.next_hop_in_ip_address, null) : null


}

