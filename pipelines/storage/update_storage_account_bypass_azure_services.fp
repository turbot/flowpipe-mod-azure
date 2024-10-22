pipeline "update_storage_account_bypass_azure_services" {
  title       = "Update Storage Account Bypass Azure Services"
  description = "Update the bypass setting of a storage account to bypass Azure services."

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

  step "container" "update_storage_account_bypass_azure_services" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "storage", "account", "update",
      "--name", param.account_name,
      "--resource-group", param.resource_group,
      "--bypass", "AzureServices",
      "--subscription", param.subscription_id
    ]

    env = param.conn.env
  }

  output "bypass_azure_services" {
    description = "The updated storage account bypass setting details."
    value       = jsondecode(step.container.update_storage_account_bypass_azure_services.stdout)
  }
}
