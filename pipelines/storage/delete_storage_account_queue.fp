pipeline "delete_storage_queue" {
  title       = "Delete Storage Queue"
  description = "Delete the specified queue and any messages it contains."

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
    default     = var.subscription_id
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

  param "storage_queue_name" {
    type        = string
    description = "The queue name."
  }

  param "account_name" {
    type        = string
    description = "The storage account name."
  }

  step "container" "delete_storage_queue" {
    image = "my-azure-image"
    cmd   = ["storage", "queue", "delete", "--subscription", param.subscription_id, "-n", param.storage_queue_name, "--account-name", param.account_name]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "storage_queue" {
    description = "The deleted storage queue details."
    value       = step.container.delete_storage_queue.stdout
  }
}
