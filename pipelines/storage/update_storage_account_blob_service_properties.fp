pipeline "update_storage_account_blob_service_properties" {
  title       = "Update Storage Account Blob Service Properties"
  description = "Update the blob service properties of a storage account."

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

  param "account_name" {
    type        = string
    description = "The storage account name."
  }

  param "enable_container_delete_retention" {
    type        = bool
    description = "Flag to enable or disable container delete retention."
  }

  param "container_delete_retention_days" {
    type        = number
    description = "The number of days to retain deleted containers."
  }

  step "container" "update_storage_account_blob_service_properties" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = concat(
      [
        "storage", "account", "blob-service-properties", "update",
        "--account-name", param.account_name,
        "--resource-group", param.resource_group,
        "--subscription", param.subscription_id
      ],
      param.enable_container_delete_retention ?
        concat(["--enable-container-delete-retention", "true", "--container-delete-retention-days", tostring(param.container_delete_retention_days)]) :
        ["--enable-container-delete-retention", "false"]
    )

    env = param.conn.env
  }

  output "blob_service_properties" {
    description = "The updated storage account blob service properties details."
    value       = jsondecode(step.container.update_storage_account_blob_service_properties.stdout)
  }
}
