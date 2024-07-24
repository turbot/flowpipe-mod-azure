pipeline "update_storage_account_logging" {
  title       = "Update Storage Account Logging"
  description = "Update the logging settings of a storage account."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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

	step "query" "get_storage_account_key" {
    database = var.database
    sql = <<-EOQ
      select
        k ->> 'Value' as access_key
      from
        azure_storage_account,
				jsonb_array_elements(access_keys) as k
      where
        name = '${param.account_name}'
				and subscription_id = '${param.subscription_id}' limit 1;
    EOQ
  }

  step "container" "update_storage_account_logging" {
		depends_on = [step.query.get_storage_account_key]
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "storage", "logging", "update",
      "--account-name", param.account_name,
      "--account-key", step.query.get_storage_account_key.rows[0].access_key,
      "--services", param.services,
      "--log", param.log,
      "--retention", tostring(param.retention),
      "--subscription", param.subscription_id
    ]

    env = credential.azure[param.cred].env
  }

}
