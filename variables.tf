variable "global_settings" {
  description = "Global settings object for the current deployment."
  default = {

    passthrough    = false
    random_length  = 4
    prefixes       = ["MAF"]
    default_region = "region1"
    use_slug       = false
    regions = {
      region1 = "uaenorth"

    }

  }
}

### skip this for now related to tagging policy
variable "policy_rg_tags" {
  default = {
    "Environment"     = "poc"
    "Description"     = "this is a poc environment"
    "Project"         = "proc-project"
    "Owner"           = "infra-team"
    "BusinessUnit"    = "IT"
    "OpCo"            = "prop"
    "Confidentiality" = "C4"
    "ServiceLevel"    = "Basic"
    "SecurityOwner"   = "santhosh.palanivel@maf.ae"
    "TechnicalOwner"  = "suraj.rajan@maf.ae"

  }


}

variable "resource_group_location" {
  default = "uaenorth"


}


variable "log_analytics" {
  description = "Configuration object - Log Analytics resources."
  default = {
    name = "test"

    region = "southeastasia"
  }
}



variable "resource_groups" {
  description = "Configuration object - Resource groups."
  default     = {}
}
variable "diagnostics" {
  description = "Configuration object - Diagnostics object."
  default = {
    diagnostics_definition = {

    }
  }
}
variable "settings" { default = {} }
variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
  default     = "test2"
}



variable "client_config" {
  default = {}
}

variable "networking" {
  description = "Configuration object - networking resources"
  default = {
    vnets = {
      vnet1 = {
        resource_group_key = "vm_region1"
        vnet = {
          name          = "virtual_machines"
          address_space = ["10.100.100.0/24"]
          dns_servers   = ["10.100.100.1", "10.100.100.2"]

        }

        subnets = {
          example = {
            name            = "examples"
            cidr            = ["10.100.100.0/29"]
            route_table_key = ""
            nsg_key         = "network_security_group1"
          }
        }
      }

    },

    vnet_peerings = {
      name                         = "peering1"
      remote_virtual_network_id    = "/subscriptions/646497f2-cf94-40d9-9ea0-0bb44fcce127/resourceGroups/vnet-peering-test/providers/Microsoft.Network/virtualNetworks/vnet-hub"
      remote_resource_group_name   = "vnet-peering-test"
      remote_virtual_network_name  = "vnet-hub"
      allow_virtual_network_access = true
      allow_forwarded_traffic      = false
      allow_gateway_transit        = false
      use_remote_gateways          = false

    },
    azurerm_routes = {

      route = {
        address_prefix         = "10.100.10.0/24"
        next_hop_type          = "virtualappliance"
        next_hop_in_ip_address = "10.100.10.90"
      }
      route2 = {
        address_prefix         = "10.100.11.0/24"
        next_hop_type          = "virtualappliance"
        next_hop_in_ip_address = "10.100.10.90"


      }

    },
    network_security_group_definition = {
      network_security_group1 = {
        nsg = {
          nsg1 = {

            name                       = "Inbound-HTTP",
            priority                   = "120"
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "80-82"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }
          nsg2 = {

            name                       = "Inbound-HTTPs",
            priority                   = "130"
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "443"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }
          nsg3 = {

            name                       = "Inbound-AGW",
            priority                   = "140"
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "65200-65535"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }
        }
      }
    }






  }
}
variable "environment" {
  description = "Name of the CAF environment."
  type        = string
  default     = "MAF"
}
variable "tags" {
  description = "Tags to be used for this resource deployment."
  type        = map(any)
  default     = null
}