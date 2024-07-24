pipeline "delete_network_virtual_network_gateway" {
  title       = "Delete Virtual Network Gateway"
  description = "Delete a Virtual Network Gateway."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "azure"
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
  }

  param "network_gateway_name" {
    type        = string
    description = "The name of the virtual network gateway that is being deleted."
  }

  step "container" "delete_virtual_network_gateway" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["network", "vnet-gateway", "delete", "-g", param.resource_group, "-n", param.network_gateway_name, "--subscription", param.subscription_id]

    env = credential.azure[param.cred].env
  }
}

