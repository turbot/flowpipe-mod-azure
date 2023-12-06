pipeline "delete_network_public_ip" {
  title       = "Delete Network Public IP"
  description = "Delete a public IP address."

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

  param "public_ip_name" {
    type        = string
    description = "The name of the public IP address."
  }

  step "container" "delete_network_public_ip" {
    image = "my-azure-image"
    cmd   = ["network", "public-ip", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.public_ip_name]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "public_ip" {
    description = "The deleted public IP details."
    value       = step.container.delete_network_public_ip.stdout
  }
}
