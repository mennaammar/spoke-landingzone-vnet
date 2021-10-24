data "azurerm_policy_definition" "Deny-PublicIP" {
  display_name = "Network interfaces should not have public IPs"
}
module "Deny-PublicIP" {
  source                  = "./modules/policy/def_resource_group_assignment"
  assignment_display_name = "Deny-PublicIP"
  assignment_description  = "Prevent Public IP based services"
  definition              = data.azurerm_policy_definition.Deny-PublicIP
  assignment_scope        = module.resource_groups.id

}

# deny next hop ip address not in this list. 
module "deny_unapproved_udr" {
  source          = "./modules/policy/definition"
  policy_name     = "deny_unapproved_udr"
  display_name    = "Deny undefined UDR in Route table"
  policy_category = "Network"
  /*** authority need to be checked with Santhosh*/
  # management_group_name = "Tenant Root Group"
}
module "deny_unapproved_udr_assign" {
  source                  = "./modules/policy/def_resource_group_assignment"
  assignment_display_name = "deny_unapproved_udr"
  assignment_description  = "deny_unapproved_udr"
  definition              = module.deny_unapproved_udr.definition
  assignment_scope        = module.resource_groups.id
  assignment_parameters   = { "allowedHops" = ["10.100.10.90"] }

}

# deny next hop type not in this list
module "deny_unapproved_udr_hop_type" {
  source          = "./modules/policy/definition"
  policy_name     = "deny_unapproved_udr_hop_type"
  display_name    = "Deny Unapproved UDR Hope Type"
  policy_category = "Network"
  /*** authority need to be checked with Santhosh*/
  # management_group_name = "Tenant Root Group"

}

module "deny_unapproved_udr_hop_type_assign" {
  source                  = "./modules/policy/def_resource_group_assignment"
  assignment_display_name = "deny_unapproved_udr_hop_type"
  assignment_description  = "deny_unapproved_udr_hop_type"
  definition              = module.deny_unapproved_udr_hop_type.definition
  assignment_scope        = module.resource_groups.id

  assignment_parameters = { "allowedHopType1" = "VirtualAppliance" }
}


data "azurerm_policy_definition" "Deny_unapproved_locations" {
  display_name = "Allowed locations"
}

## Can be assigned at subscription level.
module "Deny_unapproved_locations" {
  source                  = "./modules/policy/def_subscription_assignment"
  assignment_display_name = "Deny_unapproved_locations"
  assignment_description  = "Allowed locations"
  definition              = data.azurerm_policy_definition.Deny_unapproved_locations
 # assignment_scope        = module.resource_groups.id
  assignment_scope ="/subscriptions/646497f2-cf94-40d9-9ea0-0bb44fcce127"
  assignment_parameters   = { "listOfAllowedLocations" = ["westeurope", "uaenorth", "uaecentral"] } /* to be checked with Santhosh*/
}

data "azurerm_policy_definition" "Deny_unapproved_locations_resource_groups" {
  display_name = "Allowed locations for resource groups"
}

module "Deny_unapproved_locations_resource_groups" {
  source                  = "./modules/policy/def_subscription_assignment"
  assignment_display_name = "Deny_unapproved_locations_resource_groups"
  assignment_description  = "Deny unapproved locations resource groups"
  definition              = data.azurerm_policy_definition.Deny_unapproved_locations_resource_groups
 # assignment_scope        = module.resource_groups.id
  assignment_scope ="/subscriptions/646497f2-cf94-40d9-9ea0-0bb44fcce127"
  assignment_parameters   = { "listOfAllowedLocations" = ["westeurope", "uaenorth", "uaecentral"] } /* to be checked with Santhosh*/
}


module "deny_vpn_gateway_basic_sku" {
  source          = "./modules/policy/definition"
  policy_name     = "deny_vpn_gateway_basic_sku"
  display_name    = "Deny VPN Gateway with SKU basic"
  policy_category = "Network"
  /*** authority need to be checked with Santhosh*/
  # management_group_name = "Tenant Root Group"
}

module "deny_vpn_gateway_basic_sku_assign" {
  source                  = "./modules/policy/def_resource_group_assignment"
  assignment_display_name = "deny_vpn_gateway_basic_sku"
  assignment_description  = "deny_vpn_gateway_basic_sku"
  definition              = module.deny_vpn_gateway_basic_sku.definition
  assignment_scope        = module.resource_groups.id

}
module "deny_sql_db_tde_disabled" {
  source          = "./modules/policy/definition"
  policy_name     = "deny_sql_db_tde_disabled"
  display_name    = "deny sql db tde disabled"
  policy_category = "SQL"
  /*** authority need to be checked with Santhosh*/
  # management_group_name = "Tenant Root Group"
}

module "deny_sql_db_tde_disabled_assign" {
  source                  = "./modules/policy/def_resource_group_assignment"
  assignment_display_name = "deny_sql_db_tde_disabled"
  assignment_description  = "deny_sql_db_tde_disabled"
  definition              = module.deny_sql_db_tde_disabled.definition
  assignment_scope        = module.resource_groups.id

}
module "deny_private_dns_zones" {
  source          = "./modules/policy/definition"
  policy_name     = "deny_private_dns_zones"
  display_name    = "deny private dns zones in scope"
  policy_category = "Network"
  /*** authority need to be checked with Santhosh*/
  # management_group_name = "Tenant Root Group"
}
module "deny_private_dns_zones_assign" {
  source                  = "./modules/policy/def_resource_group_assignment"
  assignment_display_name = "deny_private_dns_zones"
  assignment_description  = "deny private dns zones in scope"
  definition              = module.deny_private_dns_zones.definition
  assignment_scope        = "/subscriptions/646497f2-cf94-40d9-9ea0-0bb44fcce127/resourceGroups/test-deny"

}

data "azurerm_policy_definition" "deploy-azurebackup-on-vm" {
  display_name = "Azure Backup should be enabled for Virtual Machines"
}

module "deploy-azurebackup-on-vm" {
  source                  = "./modules/policy/def_resource_group_assignment"
  assignment_display_name = "deploy-azureBackup-on-vm"
  assignment_description  = "Azure Backup should be enabled for Virtual Machines"
  definition              = data.azurerm_policy_definition.deploy-azurebackup-on-vm
  assignment_scope        = module.resource_groups.id

}

module "deny_public_appgw" {
  source          = "./modules/policy/definition"
  policy_name     = "deny_public_appgw"
  display_name    = "deny public IP application gateway"
  policy_category = "Network"
  /*** authority need to be checked with Santhosh*/
  # management_group_name = "Tenant Root Group"
}

module "deny_public_appgw_assign" {
  source                  = "./modules/policy/def_resource_group_assignment"
  assignment_display_name = "deny_public_appgw"
  assignment_description  = "deny public IP application gateway"
  definition              = module.deny_public_appgw.definition
  assignment_scope        = module.resource_groups.id

}


########
#Tagging:
##########
# data "azurerm_policy_definition" "require_Name_tag_resources" {
#   display_name = "Require a tag on resources"
# }

# module "require_Name_tag_resources_assign" {
#   source                  = "./modules/policy/def_assignment"
#   assignment_display_name = "require_Name_tag_resources"
#   assignment_description  = "require tags resources"
#   definition              = data.azurerm_policy_definition.require_Name_tag_resources
#   assignment_scope        = module.resource_groups.id
#   assignment_parameters = {"tagName"="Name"}
# }

# data "azurerm_policy_definition" "require_Description_tag_resources" {
#   display_name = "Require a tag on resources"
# }

# module "require_Description_tag_resources_assign" {
#   source                  = "./modules/policy/def_assignment"
#   assignment_display_name = "require_Description_tag_resources"
#   assignment_description  = "require tags resources"
#   definition              = data.azurerm_policy_definition.require_Description_tag_resources
#   assignment_scope        = module.resource_groups.id
#    assignment_parameters = {"tagName"="Description"}

# }

module "deny_network_interface_ip_forwarding" {
  source          = "./modules/policy/definition"
  policy_name     = "deny_network_interface_ip_forwarding"
  display_name    = "Deny network interface ip forwarding"
  policy_category = "Network"

  #assignment_effect = "Modify"
  /*** authority need to be checked with Santhosh*/
  # management_group_name = "Tenant Root Group"
}
module "deny_network_interface_ip_forwarding_assign" {
  source                  = "./modules/policy/def_resource_group_assignment"
  assignment_display_name = "deny_network_interface_ip_forwarding"
  assignment_description  = "Deny network interface ip forwarding"
  definition              = module.deny_network_interface_ip_forwarding.definition
  assignment_scope        = module.resource_groups.id

}

module "deny_subnet_without_nsg" {
  source          = "./modules/policy/definition"
  policy_name     = "deny_subnet_without_nsg"
  display_name    = "Subnets should be associated with a Network Security Group"
  policy_category = "Network"
  #  /*** authority need to be checked with Santhosh*/
  # management_group_name = "Tenant Root Group"
}

module "deny_subnet_without_nsg_assign" {
  source                  = "./modules/policy/def_resource_group_assignment"
  assignment_display_name = "deny_subnet_without_nsg"
  assignment_description  = "Subnets should be associated with a Network Security Group"
  definition              = module.deny_subnet_without_nsg.definition
  assignment_scope        = module.resource_groups.id

}



#audit-sql-db-auditing
module "audit-sql-db-auditing" {
  source          = "./modules/policy/definition"
  policy_name     = "audit-sql-db-auditing"
  display_name    = "Audit SQL DB server Auditing Settings"
  policy_category = "SQL"
  /*** authority need to be checked with Santhosh*/
  # management_group_name = "Tenant Root Group"
}
module "audit-sql-db-auditing-assign" {
  source                  = "./modules/policy/def_resource_group_assignment"
  assignment_display_name = "audit-sql-db-auditing-assignment"
  assignment_description  = "Audit SQL DB server Auditing Settings"
  definition              = module.audit-sql-db-auditing.definition
  assignment_scope        = module.resource_groups.id



}

### SQL vulnerability assessment. 

data "azurerm_policy_definition" "audit_sql_vulnerabilityAssessments" {
  display_name = "Vulnerability assessment should be enabled on your SQL servers"
}
module "audit_sql_vulnerabilityAssessments_assign" {
  source                  = "./modules/policy/def_resource_group_assignment"
  assignment_display_name = "audit_sql_vulnerabilityAssessments"
  assignment_description  = "Audit Sql vulnerability Assessments"
  definition              = data.azurerm_policy_definition.audit_sql_vulnerabilityAssessments
  assignment_scope        = module.resource_groups.id

}






