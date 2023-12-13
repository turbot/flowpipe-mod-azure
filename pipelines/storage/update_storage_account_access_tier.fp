pipeline "update_storage_account_access_tier" {
  title       = "Update Storage Account Access Tier"
  description = "Update the access tier of a storage account."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
    default     = var.subscription_id
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
    default     = var.resource_group
  }

  param "account_name" {
    type        = string
    description = "The storage account name."
  }

  param "access_tier" {
    type        = string
    description = "The access tier is used for billing."
  }

  step "container" "update_storage_account_access_tier" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["storage", "account", "update", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.account_name, "--access-tier", param.access_tier]

    env = credential.azure[param.cred].env
  }

  output "access_tier" {
    description = "The updated storage account access tier details."
    value       = jsondecode(step.container.update_storage_account_access_tier.stdout)
  }
}
