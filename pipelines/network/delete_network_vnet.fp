pipeline "delete_network_vnet" {
  title       = "Delete Network VNet"
  description = "Delete a virtual network."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

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

  param "vnet_name" {
    type        = string
    description = "The virtual network (VNet) name."
  }

  step "container" "delete_network_vnet" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["network", "vnet", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.vnet_name]

    env = credential.azure[param.cred].env
  }

  output "vnet" {
    description = "The deleted VNet details."
    value       = jsondecode(step.container.delete_network_vnet.stdout)
  }
}
