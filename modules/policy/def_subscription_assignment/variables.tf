variable "definition" {
  type        = any
  description = "Policy Definition resource node"
}

variable "assignment_scope" {
  type        = string
  description = "The scope at which the policy will be assigned. Must be full resource IDs. Changing this forces a new resource to be created"
}

variable "assignment_not_scopes" {
  type        = list(any)
  description = "A list of the Policy Assignment's excluded scopes. Must be full resource IDs"
  default     = []
}

variable "assignment_display_name" {
  type        = string
  description = "The policy assignment display name, if blank the definition display_name will be used. Changing this forces a new resource to be created"
  default     = ""
}

variable "assignment_description" {
  type        = string
  description = "A description to use for the Policy Assignment. Changing this forces a new resource to be created"
  default     = ""
}

variable "assignment_effect" {
  type        = string
  description = "The effect of the policy. Changing this forces a new resource to be created"
  default     = null
}

variable "assignment_parameters" {
  type        = any
  description = "The policy assignment parameters. Changing this forces a new resource to be created"
  default     = null
}

variable "assignment_enforcement_mode" {
  type        = bool
  description = "Can be set to 'true' or 'false' to control whether the assignment is enforced"
  default     = true
}

variable "assignment_location" {
  type        = string
  description = "The Azure location where this policy assignment should exist, required when an Identity is assigned. Defaults to UK South. Changing this forces a new resource to be created"
  default     = "uaenorth"
}

variable "skip_remediation" {
  type        = bool
  description = "Should the module skip creation of a remediation task for policies that DeployIfNotExists and Modify"
  default     = false
}

locals {
  # assignment_name will be trimmed if exceeds 24 characters
  ##assignment_name = lower(substr(var.definition.name, 0, 24))
  /* had to be changed to work with the built-in policies -- Menna */
  assignment_name = var.assignment_display_name != "" ? var.assignment_display_name : lower(substr(var.definition.name, 0, 24))

  # definition display_name will be used if omitted
  display_name = var.assignment_display_name != "" ? var.assignment_display_name : var.definition.display_name

  # definition discription will be used if omitted
  description = var.assignment_description != "" ? var.assignment_description : var.definition.description

  # convert assignment parameters to the required assignment structure
  parameter_values = var.assignment_parameters != null ? {
    for key, value in var.assignment_parameters :
    key => merge({ value = value })
  } : null

  # merge effect with parameter_values if specified, will use definition defaults if omitted
  # Menna -- commented as not all the built-in policies has effect as parameter. will be put in parameters array instead.
  #parameters = var.assignment_effect != null ? jsonencode(merge(local.parameter_values, { effect = { value = var.assignment_effect } })) : jsonencode(local.parameter_values)
  parameters = jsonencode(local.parameter_values)
  # determine managed identity type from effect
  identity_type = var.assignment_effect != null ? contains(["DeployIfNotExists", "Modify"], var.assignment_effect) ? "SystemAssigned" : "None" : "None"

  # create a remediation task for policies with DeployIfNotExists and Modify effects only if var.skip_remediation != false
  create_remediation = var.skip_remediation == false ? var.assignment_effect != null ? contains(["DeployIfNotExists", "Modify"], var.assignment_effect) ? true : false : false : false
}
