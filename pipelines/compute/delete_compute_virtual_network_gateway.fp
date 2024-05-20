
pipeline "delete_compute_virtual_network_gateway" {
  title       = "Delete Compute Virtual Network Gateway"
  description = "Delete a Compute Virtual Network Gateway."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
  }

  param "name" {
    type        = string
    description = "The name of the network gateway that is being deleted."
  }

  step "container" "delete_network_gateway" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["network", "vnet-gateway", "delete", "--yes", "-g", param.resource_group, "-n", param.name, "--subscription", param.subscription_id]

    env = credential.azure[param.cred].env
  }

  output "gateway" {
    description = "The deleted network gateway details."
    value       = jsondecode(step.container.delete_network_gateway.stdout)
  }
}
