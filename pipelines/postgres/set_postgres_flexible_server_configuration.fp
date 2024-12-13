pipeline "set_postgres_flexible_server_configuration" {
  title       = "Set PostgreSQL Flexible Server Configuration"
  description = "Set a configuration value for a postgres flexible server."

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
    description = "The name of the PostgreSQL flexible server."
  }

  param "config_name" {
    type        = string
    description = "The name of the configuration setting."
  }

  param "config_value" {
    type        = string
    description = "The value of the configuration setting."
  }

  step "container" "set_postgres_flexible_server_configuration" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "postgres", "flexible-server", "parameter", "set",
      "--resource-group", param.resource_group,
      "--server-name", param.server_name,
      "--name", param.config_name,
      "--value", param.config_value,
      "--subscription", param.subscription_id
    ]

    env = param.conn.env
  }

  output "flexible_server_configuration" {
    description = "The updated PostgreSQL flexible server configuration details."
    value       = jsondecode(step.container.set_postgres_flexible_server_configuration.stdout)
  }
}
