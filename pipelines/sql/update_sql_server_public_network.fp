pipeline "update_sql_server_public_network_access" {
  title       = "Update SQL Server Public Network Access"
  description = "Enable or disable public network access for the specified SQL server."

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

  param "server_name" {
    type        = string
    description = "The SQL server name."
  }

  param "enable_public_network" {
    type        = bool
    description = "Enable or disable public network access for the SQL server. Accepted values: true, false."
  }

  step "container" "update_sql_server_public_network_access" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "sql", "server", "update",
      "--resource-group", param.resource_group,
      "--subscription", param.subscription_id,
      "--name", param.server_name,
      "--enable-public-network", tostring(param.enable_public_network)
    ]

    env = param.conn.env
  }

  output "sql_server_public_network_status" {
    description = "The updated public network access setting for the SQL server."
    value       = jsondecode(step.container.update_sql_server_public_network_access.stdout)
  }
}
