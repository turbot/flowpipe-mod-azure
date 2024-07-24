pipeline "update_storage_account_https_only" {
  title       = "Update Storage Account HTTPS-Only Setting"
  description = "Update the HTTPS-only setting of a storage account."

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

  param "account_name" {
    type        = string
    description = "The storage account name."
  }

  param "https_only" {
    type        = bool
    description = "Flag to enable or disable HTTPS-only access."
  }

  step "container" "update_storage_account_https_only" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "storage", "account", "update",
      "--name", param.account_name,
      "--resource-group", param.resource_group,
      "--subscription", param.subscription_id,
      "--https-only", tostring(param.https_only)
    ]

    env = credential.azure[param.cred].env
  }

  output "https_only" {
    description = "The updated storage account HTTPS-only setting details."
    value       = jsondecode(step.container.update_storage_account_https_only.stdout)
  }
}
