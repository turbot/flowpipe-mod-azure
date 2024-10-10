pipeline "delete_network_firewall" {
  title       = "Delete Network Firewall"
  description = "Delete an Azure Firewall."

  tags = {
    type = "featured"
  }

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

  step "container" "delete_network_firewall" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["network", "firewall", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.firewall_name]

    env = param.conn.env
  }

  output "firewall" {
    description = "The deleted network firewall details."
    value       = jsondecode(step.container.delete_network_firewall.stdout)
  }
}
