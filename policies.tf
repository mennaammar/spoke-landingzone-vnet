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
