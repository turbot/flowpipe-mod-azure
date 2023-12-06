pipeline "create_network_nat_gateway" {
  title       = "Create Network Nat Gateway"
  description = "Create a NAT gateway."

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

  param "gateway_name" {
    type        = string
    description = "Name of the NAT gateway."
  }

  step "container" "create_network_nat_gateway" {
    image = "my-azure-image"
    cmd   = ["network", "nat", "gateway", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.gateway_name]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "nat_gateway" {
    description = "The created nat gateway details."
    value       = step.container.create_network_nat_gateway.stdout
  }
}
