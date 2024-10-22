pipeline "create_network_nat_gateway" {
  title       = "Create Network Nat Gateway"
  description = "Create a NAT gateway."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
  }

  param "gateway_name" {
    type        = string
    description = "Name of the NAT gateway."
  }

  step "container" "create_network_nat_gateway" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["network", "nat", "gateway", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.gateway_name]

    env = param.conn.env
  }

  output "nat_gateway" {
    description = "The created nat gateway details."
    value       = jsondecode(step.container.create_network_nat_gateway.stdout)
  }
}
