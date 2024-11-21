pipeline "set_sql_server_tde_key" {
  title       = "Set SQL Server TDE Key"
  description = "Set the Transparent Data Encryption (TDE) key for the specified SQL server using a Key Vault key."

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

  param "server_key_type" {
    type        = string
    description = "The server key type. Accepted value: AzureKeyVault."
    default     = "AzureKeyVault"
  }

  param "key_identifier" {
    type        = string
    description = "The Key Vault key identifier to use for Transparent Data Encryption."
  }

  step "container" "set_sql_server_tde_key" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "sql", "server", "tde-key", "set",
      "--resource-group", param.resource_group,
      "--subscription", param.subscription_id,
      "--server", param.server_name,
      "--server-key-type", param.server_key_type,
      "--kid", param.key_identifier
    ]

    env = param.conn.env
  }

  output "tde_key_status" {
    description = "The updated TDE key status for the SQL server."
    value       = jsondecode(step.container.set_sql_server_tde_key.stdout)
  }
}
