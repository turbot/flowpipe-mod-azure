pipeline "delete_storage_account" {
  title       = "Delete Storage Account"
  description = "Delete a storage account."

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

  step "container" "delete_storage_account" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["storage", "account", "delete", "--yes", "-g", param.resource_group, "-n", param.account_name, "--subscription", param.subscription_id]

    env = param.conn.env
  }

  output "account" {
    description = "The deleted storage account details."
    value       = jsondecode(step.container.delete_storage_account.stdout)
  }
}
