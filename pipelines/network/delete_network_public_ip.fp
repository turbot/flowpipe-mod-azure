pipeline "delete_network_public_ip" {
  title       = "Delete Network Public IP"
  description = "Delete a public IP address."

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

  param "public_ip_name" {
    type        = string
    description = "The name of the public IP address."
  }

  step "container" "delete_network_public_ip" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["network", "public-ip", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.public_ip_name]

    env = credential.azure[param.cred].env
  }
}
