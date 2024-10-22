pipeline "update_storage_account_logging" {
  title       = "Update Storage Account Logging"
  description = "Update the logging settings of a storage account."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "account_name" {
    type        = string
    description = "The storage account name."
  }

  param "services" {
    type        = string
    description = "The services to enable logging for."
    default     = "b"
  }

  param "log" {
    type        = string
    description = "The logging operations (read, write, delete)."
    default     = "rwd"
  }

  param "retention" {
    type        = number
    description = "The number of days to retain the logs."
    default     = 90
  }

  param "access_key" {
    type        = string
    description = "Access Key for logging."
  }

  step "container" "update_storage_account_logging" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "storage", "logging", "update",
      "--account-name", param.account_name,
      "--account-key", param.access_key,
      "--services", param.services,
      "--log", param.log,
      "--retention", tostring(param.retention),
      "--subscription", param.subscription_id
    ]

    env = param.conn.env
  }

}
