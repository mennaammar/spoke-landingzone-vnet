# module org_mg_storage_enforce_https {
#   source            = "./modules/policy/def_assignment"
#   definition        = module.storage_enforce_https.definition
#   assignment_scope  = module.resource_groups.id
#   assignment_effect = "Deny"
# }

# module storage_enforce_https {
#   source                = "./modules/policy/definition"
#   policy_name           = "storage_enforce_https"
#   display_name          = "Secure transfer to storage accounts should be enabled"
#   policy_category       = "Storage"
#   policy_mode           = "Indexed"
#   management_group_name = "Tenant Root Group"
# }
## definition ID=/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114

module "Deny-PublicIP" {
  source                  = "./modules/policy/def_assignment"
  assignment_display_name = "Deny-PublicIP"
  assignment_description  = "Prevent Public IP based services"
  definition              = data.azurerm_policy_definition.Deny-PublicIP
  assignment_scope        = module.resource_groups.id


}

data "azurerm_policy_definition" "Deny-PublicIP" {
  display_name = "Network interfaces should not have public IPs"
}


data "azurerm_policy_definition" "Enforce-tagging" {
  display_name = "Append a tag and its value to resources"
}
