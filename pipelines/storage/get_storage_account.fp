pipeline "get_storage_account" {
  title       = "Get Storage Account"
  description = "Get a storage account."

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

  step "container" "get_storage_account" {
    image = "my-azure-image"
    cmd   = ["storage", "account", "show", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.account_name]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "account" {
    description = "The storage account details."
    value       = jsondecode(step.container.get_storage_account.stdout)
  }
}
