pipeline "update_storage_account_access_tier" {
  title       = "Update Storage Account Access Tier"
  description = "Update the access tier of a storage account."

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

  param "tenant_id" {
    type        = string
    description = local.tenant_id_param_description
    default     = var.tenant_id
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
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
    image = "my-azure-image"
    cmd   = ["storage", "account", "update", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.account_name, "--access-tier", param.access_tier]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "access_tier" {
    description = "The updated storage account access tier details."
    value       = step.container.update_storage_account_access_tier.stdout
  }
}
