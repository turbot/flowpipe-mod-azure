pipeline "delete_storage_account" {
  title       = "Delete Storage Account"
  description = "Delete a storage account."

  tags = {
    type = "featured"
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

  step "container" "delete_storage_account" {
    image = "my-azure-image"
    cmd   = ["storage", "account", "delete", "--yes", "-g", param.resource_group, "-n", param.account_name, "--subscription", param.subscription_id]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "account" {
    description = "The deleted storage account details."
    value       = jsondecode(step.container.delete_storage_account.stdout)
  }
}