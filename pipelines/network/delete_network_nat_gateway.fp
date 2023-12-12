pipeline "delete_network_nat_gateway" {
  title       = "Delete Network Nat Gateway"
  description = "Delete a NAT gateway."

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

  step "container" "delete_network_nat_gateway" {
    image = "my-azure-image"
    cmd   = ["network", "nat", "gateway", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.gateway_name]

    env = credential.azure[param.cred].env
  }

  output "nat_gateway" {
    description = "The deleted nat gateway details."
    value       = jsondecode(step.container.delete_network_nat_gateway.stdout)
  }
}
