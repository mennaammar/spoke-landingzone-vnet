
variable "tags" {
  description = "(Required) Map of tags to be applied to the resource"
  type        = map(any)
}

variable "location" {}
variable "name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
}
