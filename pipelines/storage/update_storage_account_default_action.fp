pipeline "update_storage_account_default_action" {
  title       = "Update Storage Account Default Action"
  description = "Update the default action of a storage account to Deny."

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

  param "default_action" {
    type        = string
    description = "The default action for the storage account. Accepted values: Allow, Deny."
    default     = "Deny"
  }

  step "container" "update_default_action" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = concat(
      [
        "storage", "account", "update",
        "--resource-group", param.resource_group,
        "--subscription", param.subscription_id,
        "--name", param.account_name,
        "--default-action", param.default_action
      ],
    )

    env = credential.azure[param.cred].env
  }

  output "default_action" {
    description = "The updated default action details."
    value       = jsondecode(step.container.update_default_action.stdout)
  }
}
