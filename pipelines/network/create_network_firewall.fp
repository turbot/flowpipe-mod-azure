pipeline "create_network_firewall" {
  title       = "Create Network Firewall"
  description = "Create an Azure Firewall."

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

  param "firewall_name" {
    type        = string
    description = "Azure Firewall name."
  }

  step "container" "create_network_firewall" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["network", "firewall", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.firewall_name]

    env = param.conn.env
  }

  output "firewall" {
    description = "The created network firewall."
    value       = jsondecode(step.container.create_network_firewall.stdout)
  }
}
