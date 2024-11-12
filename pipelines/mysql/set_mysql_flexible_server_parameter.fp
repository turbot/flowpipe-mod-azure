pipeline "set_mysql_flexible_server_parameter" {
  title       = "Set MySQL flexible server parameter"
  description = "Set a parameter value for a MySQL flexible server."

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
    description = "The name of the MySQL flexible server."
  }

  param "parameter_name" {
    type        = string
    description = "The name of the parameter to set."
  }

  param "parameter_value" {
    type        = string
    description = "The value of the parameter to set."
  }

  step "container" "set_mysql_flexible_server_parameter" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "mysql", "flexible-server", "parameter", "set",
      "--resource-group", param.resource_group,
      "--server-name", param.server_name,
      "--name", param.parameter_name,
      "--value", param.parameter_value,
      "--subscription", param.subscription_id
    ]

    env = param.conn.env
  }

  output "flexible_server_parameter" {
    description = "The updated MySQL flexible server parameter details."
    value       = jsondecode(step.container.set_mysql_flexible_server_parameter.stdout)
  }
}
