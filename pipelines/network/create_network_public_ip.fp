pipeline "create_network_public_ip" {
  title       = "Create Network Public IP"
  description = "Create a public IP address."

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

  param "public_ip_name" {
    type        = string
    description = "The name of the public IP address."
  }

  param "sku" {
    type        = string
    description = "Name of a public IP address SKU."
    optional    = true
  }

  step "container" "create_network_public_ip" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = concat(
      ["network", "public-ip", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.public_ip_name],
      param.sku != null ? concat(["--sku", param.sku]) : []
    )

    env = credential.azure[param.cred].env
  }

  output "public_ip" {
    description = "The created public IP details."
    value       = jsondecode(step.container.create_network_public_ip.stdout)
  }
}
