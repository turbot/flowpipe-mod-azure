pipeline "update_storage_account_public_network_access" {
  title       = "Update Storage Account Public Network Access"
  description = "Update the public network access of a storage account."

  param "subscription_id" {
    type        = string
    description = "Azure Subscription Id."
    default     = var.subscription_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "resource_group" {
    type        = string
    description = "Azure Resource Group."
    default     = var.resource_group
    # TODO: Add once supported
    #sensitive   = true
  }

  param "tenant_id" {
    type        = string
    description = "The Microsoft Entra ID tenant (directory) ID."
    default     = var.tenant_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = "A client secret that was generated for the App Registration."
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = "The client (application) ID of an App Registration in the tenant."
    default     = var.client_id
    # TODO: Add once supported
    #sensitive   = true
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

  output "stdout" {
    description = "Storage account public network access output."
    value       = jsondecode(step.container.update_storage_account_public_network_access.stdout)
  }

  output "stderr" {
    description = "Storage account public network access error."
    value       = step.container.update_storage_account_public_network_access.stderr
  }
}
