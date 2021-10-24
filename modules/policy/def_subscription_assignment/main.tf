resource "azurerm_subscription_policy_assignment" "def" {
  name                 = local.assignment_name
  display_name         = local.display_name
  description          = local.description
  subscription_id                = var.assignment_scope
  not_scopes           = var.assignment_not_scopes
  enforce     = var.assignment_enforcement_mode
  policy_definition_id = var.definition.id
  metadata             = var.definition.metadata
  parameters           = local.parameters != "null" ? local.parameters : ""
  location             = var.assignment_location


# it doesn't accept any None or null. Either set or not. it will create a managed identity with every assignment.
  
 dynamic "identity" {
 for_each = local.create_remediation == 1? [1]:[]
content {
    type = local.identity_type
}
   
  } 
  lifecycle {
    #create_before_destroy = true /* caused issues in replacement*/
    ignore_changes = [
      metadata
    ]
  }
}

resource "azurerm_role_assignment" "assignment" {
  count = local.create_remediation ? 1 : 0
  scope                = azurerm_subscription_policy_assignment.def.subscription_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_subscription_policy_assignment.def.identity[0].principal_id
  depends_on           = [azurerm_subscription_policy_assignment.def]
}

resource "azurerm_policy_remediation" "rem" {
  count                   = local.create_remediation ? 1 : 0
  name                    = lower("${var.definition.name}-${formatdate("DD-MM-YYYY-hh:mm:ss", timestamp())}")
  scope                   = var.assignment_scope
  resource_discovery_mode = "ReEvaluateCompliance"
  policy_assignment_id    = azurerm_subscription_policy_assignment.def.id

  depends_on = [azurerm_role_assignment.assignment]
}

