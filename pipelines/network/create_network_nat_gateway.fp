pipeline "create_network_nat_gateway" {
  title       = "Create Network Nat Gateway"
  description = "Create a NAT gateway."

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

  param "gateway_name" {
    type        = string
    description = "Name of the NAT gateway."
  }

  step "container" "create_network_nat_gateway" {
    image = "my-azure-image"
    cmd   = ["network", "nat", "gateway", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.gateway_name]

    env = credential.azure[param.cred].env
  }

  output "nat_gateway" {
    description = "The created nat gateway details."
    value       = jsondecode(step.container.create_network_nat_gateway.stdout)
  }
}
