pipeline "create_storage_queue" {
  title       = "Create Storage Queue"
  description = "Create a queue under the given account."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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

  step "container" "create_storage_queue" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["storage", "queue", "create", "--subscription", param.subscription_id, "-n", param.storage_queue_name, "--account-name", param.account_name]

    env = credential.azure[param.cred].env
  }

  output "queue" {
    description = "The created storage queue details."
    value       = jsondecode(step.container.create_storage_queue.stdout)
  }
}
