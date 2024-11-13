pipeline "update_storage_account_blob_public_access" {
  title       = "Update Storage Account blob public access setting"
  description = "Update the public access setting for blobs in a storage account."

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

  param "allow_blob_public_access" {
    type        = bool
    description = "Flag to enable or disable public access to blobs."
  }

  step "container" "update_storage_account_blob_public_access" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "storage", "account", "update",
      "--name", param.account_name,
      "--resource-group", param.resource_group,
      "--subscription", param.subscription_id,
      "--allow-blob-public-access", tostring(param.allow_blob_public_access)
    ]

    env = param.conn.env
  }

  output "blob_public_access" {
    description = "The updated storage account blob public access setting details."
    value       = jsondecode(step.container.update_storage_account_blob_public_access.stdout)
  }
}
