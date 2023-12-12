pipeline "delete_storage_account" {
  title       = "Delete Storage Account"
  description = "Delete a storage account."

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

  step "container" "delete_storage_account" {
    image = "my-azure-image"
    cmd   = ["storage", "account", "delete", "--yes", "-g", param.resource_group, "-n", param.account_name, "--subscription", param.subscription_id]

    env = credential.azure[param.cred].env
  }

  output "account" {
    description = "The deleted storage account details."
    value       = jsondecode(step.container.delete_storage_account.stdout)
  }
}
