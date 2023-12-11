pipeline "delete_network_vnet" {
  title       = "Delete Network VNet"
  description = "Delete a virtual network."

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
    default     = var.subscription_id
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
    default     = var.resource_group
  }

  param "tenant_id" {
    type        = string
    description = local.tenant_id_param_description
    default     = var.tenant_id
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
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

  output "vnet" {
    description = "The deleted VNet details."
    value       = jsondecode(step.container.delete_network_vnet.stdout)
  }
}
