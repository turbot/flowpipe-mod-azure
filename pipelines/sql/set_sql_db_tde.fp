pipeline "set_sql_db_tde" {
  title       = "Set SQL Database TDE"
  description = "Set Transparent Data Encryption (TDE) status for the specified SQL database."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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

  param "database_name" {
    type        = string
    description = "The SQL database name."
  }

  param "status" {
    type        = string
    description = "The TDE status for the SQL database. Accepted values: Enabled, Disabled."
  }

  step "container" "set_sql_db_tde" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["sql", "db", "tde", "set", "-g", param.resource_group, "--subscription", param.subscription_id, "--server", param.server_name, "--database", param.database_name, "--status", param.status]

    env = credential.azure[param.cred].env
  }
}
