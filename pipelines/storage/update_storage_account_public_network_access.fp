pipeline "update_storage_account_public_network_access" {
  title       = "Update Storage Account Public Network Access"
  description = "Update the public network access of a storage account."

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

  param "public_network_access" {
    type        = bool
    description = "Enable or disable public network access to the storage account."
  }

  step "container" "update_storage_account_public_network_access" {
    image = "my-azure-image"
    cmd = concat(
      ["storage", "account", "update", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.account_name],
      param.public_network_access == true ? ["--public-network-access", "Enabled"] : ["--public-network-access", "Disabled"]
    )

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "account_public_network_access" {
    description = "The updated storage account public network access details."
    value       = jsondecode(step.container.update_storage_account_public_network_access.stdout)
  }
}