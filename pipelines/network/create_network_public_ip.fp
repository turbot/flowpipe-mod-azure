pipeline "create_network_public_ip" {
  title       = "Create Network Public IP"
  description = "Create a public IP address."

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

  param "sku" {
    type        = string
    description = "Name of a public IP address SKU."
    optional    = true
  }

  step "container" "create_network_public_ip" {
    image = "my-azure-image"
    cmd = concat(
      ["network", "public-ip", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.public_ip_name],
      param.sku != null ? concat(["--sku", param.sku]) : []
    )

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "public_ip" {
    description = "The created public IP details."
    value       = jsondecode(step.container.create_network_public_ip.stdout)
  }
}