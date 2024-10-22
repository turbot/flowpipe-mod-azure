pipeline "update_storage_account_access_tier" {
  title       = "Update Storage Account Access Tier"
  description = "Update the access tier of a storage account."

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

  param "access_tier" {
    type        = string
    description = "The access tier is used for billing."
  }

  step "container" "update_storage_account_access_tier" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["storage", "account", "update", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.account_name, "--access-tier", param.access_tier]

    env = param.conn.env
  }

  output "access_tier" {
    description = "The updated storage account access tier details."
    value       = jsondecode(step.container.update_storage_account_access_tier.stdout)
  }
}
