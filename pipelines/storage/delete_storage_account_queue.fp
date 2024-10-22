pipeline "delete_storage_queue" {
  title       = "Delete Storage Queue"
  description = "Delete the specified queue and any messages it contains."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "storage_queue_name" {
    type        = string
    description = "The queue name."
  }

  param "account_name" {
    type        = string
    description = "Storage account name."
  }

  step "container" "delete_storage_queue" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["storage", "queue", "delete", "--subscription", param.subscription_id, "-n", param.storage_queue_name, "--account-name", param.account_name]

    env = param.conn.env
  }

  output "queue" {
    description = "The deleted storage queue details."
    value       = jsondecode(step.container.delete_storage_queue.stdout)
  }
}
