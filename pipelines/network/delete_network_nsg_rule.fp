pipeline "delete_network_nsg_rule" {
  title       = "Delete Network NSG Rule"
  description = "Delete a rule from a Network Security Group (NSG) in Azure."

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

  param "nsg_name" {
    type        = string
    description = "Network Security Group name."
  }

  param "nsg_rule_name" {
    type        = string
    description = "Network Security Group rule name."
  }

  step "container" "delete_network_nsg_rule" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "network", "nsg", "rule", "delete",
      "-g", param.resource_group,
      "--subscription", param.subscription_id,
      "--nsg-name", param.nsg_name,
      "-n", param.nsg_rule_name
    ]

    env = param.conn.env
  }

   output "firewall" {
    description = "The deleted network firewall details."
    value       = (step.container.delete_network_nsg_rule.stdout)
  }

}
