pipeline "set_postgres_flexible_server_require_secure_transport" {
  title       = "Set PostgreSQL Flexible Server Require Secure Transport"
  description = "Update the require_secure_transport parameter of a PostgreSQL flexible server to enforce SSL connections."

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

  param "require_secure_transport" {
    type        = string
    description = "The require_secure_transport parameter setting (On or Off)."
  }

  step "container" "set_postgres_flexible_server_secure_transport" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "postgres", "flexible-server", "parameter", "set",
      "--resource-group", param.resource_group,
      "--server-name", param.server_name,
      "--name", "require_secure_transport",
      "--value", param.require_secure_transport,
      "--subscription", param.subscription_id
    ]

    env = param.conn.env
  }

  output "require_secure_transport_status" {
    description = "The updated status of the require_secure_transport parameter on the PostgreSQL flexible server."
    value       = jsondecode(step.container.set_postgres_flexible_server_secure_transport.stdout)
  }
}