variable "subscription_id" {
  type        = string
  description = "Azure Subscription Id. Examples: d46d7416-f95f-4771-bbb5-529d4c766."
  # TODO: Add once supported
  #sensitive  = true
}

variable "resource_group" {
  type        = string
  description = "Azure Resource Group. Examples: my_resource_group."
  # TODO: Add once supported
  #sensitive  = true
}

variable "tenant_id" {
  type        = string
  description = "The Microsoft Entra ID tenant (directory) ID."
  # TODO: Add once supported
  #sensitive  = true
}

variable "client_secret" {
  type        = string
  description = "A client secret that was generated for the App Registration."
  # TODO: Add once supported
  #sensitive  = true
}

variable "client_id" {
  type        = string
  description = "The client (application) ID of an App Registration in the tenant."
  # TODO: Add once supported
  #sensitive  = true
}