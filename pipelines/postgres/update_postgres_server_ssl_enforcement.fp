pipeline "update_postgres_server_ssl_enforcement" {
  title       = "Update PostgreSQL Server SSL Enforcement"
  description = "Update the SSL enforcement configuration of a PostgreSQL server."

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
    description = "The name of the PostgreSQL server."
  }

  param "ssl_enforcement" {
    type        = string
    description = "The SSL enforcement setting (Enabled or Disabled)."
  }

  step "container" "update_postgres_server_ssl_enforcement" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
     "postgres", "server", "update",
      "--resource-group", param.resource_group,
      "--name", param.server_name,
      "--ssl-enforcement", param.ssl_enforcement,
      "--subscription", param.subscription_id
    ]

    env = param.conn.env
  }

  output "server_ssl_enforcement" {
    description = "The updated PostgreSQL server SSL enforcement details."
    value       = jsondecode(step.container.update_postgres_server_ssl_enforcement.stdout)
  }
}
