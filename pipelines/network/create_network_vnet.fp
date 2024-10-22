pipeline "create_network_vnet" {
  title       = "Create Network VNet"
  description = "Create a virtual network."

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

  param "vnet_name" {
    type        = string
    description = "The virtual network (VNet) name."
  }

  step "container" "create_network_vnet" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["network", "vnet", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.vnet_name]

    env = param.conn.env
  }

  output "vnet" {
    description = "The created VNet details."
    value       = jsondecode(step.container.create_network_vnet.stdout)
  }
}
