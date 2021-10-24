output "id" {
  description = "The Policy Assignment Id"
  value       = azurerm_subscription_policy_assignment.def.id
}

output "identity_id" {
  description = "The Managed Identity block containing Principal Id & Tenant Id of this Policy Assignment if type is SystemAssigned"
  value       = length(azurerm_subscription_policy_assignment.def.identity) >0  ? azurerm_subscription_policy_assignment.def.identity[0].principal_id : 0
}

output "remediation_id" {
  description = "The Id of the Policy Remediation"
  value       = azurerm_policy_remediation.rem[*].id
}
