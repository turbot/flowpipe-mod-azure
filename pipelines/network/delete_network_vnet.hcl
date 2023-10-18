pipeline "delete_network_vnet" {
  title       = "Delete Network Vnet"
  description = "Delete a virtual network."

  param "subscription_id" {
    type        = string
    description = "Azure Subscription Id."
    default     = var.subscription_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "resource_group" {
    type        = string
    description = "Azure Resource Group."
    default     = var.resource_group
    # TODO: Add once supported
    #sensitive   = true
  }

  param "tenant_id" {
    type        = string
    description = "The Microsoft Entra ID tenant (directory) ID."
    default     = var.tenant_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = "A client secret that was generated for the App Registration."
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = "The client (application) ID of an App Registration in the tenant."
    default     = var.client_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "vnet_name" {
    type        = string
    description = "The virtual network (VNet) name."
  }

  step "container" "delete_network_vnet" {
    image = "my-azure-image"
    cmd   = ["network", "vnet", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.vnet_name]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stdout" {
    description = "Vnet details."
    value       = step.container.delete_network_vnet.stdout
  }

  output "stderr" {
    description = "Vnet error."
    value       = step.container.delete_network_vnet.stderr
  }
}
