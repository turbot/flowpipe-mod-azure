pipeline "delete_sql_database" {
  title       = "Delete Azure SQL Database"
  description = "Delete an Azure SQL Database."

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
    description = "The name of the SQL Server."
  }

  param "database_name" {
    type        = string
    description = "The name of the SQL Database."
  }

  step "container" "delete_sql_database" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "sql", "db", "delete",
      "--resource-group", param.resource_group,
      "--subscription", param.subscription_id,
      "--server", param.server_name,
      "--name", param.database_name,
      "--yes"
    ]

    env = credential.azure[param.cred].env
  }

}
