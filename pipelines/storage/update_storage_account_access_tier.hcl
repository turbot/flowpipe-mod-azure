pipeline "update_storage_account_access_tier" {
  title       = "Update Storage Account Access Tier"
  description = "Update the access tier of a storage account."

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

  param "access_tier" {
    type        = string
    description = "The access tier is used for billing."
  }

  step "container" "update_storage_account_access_tier" {
    image = "my-azure-image"
    cmd   = ["storage", "account", "update", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.account_name, "--access-tier", param.access_tier]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stdout" {
    description = "Storage account access tier update output."
    value       = jsondecode(step.container.update_storage_account_access_tier.stdout)
  }

  output "stderr" {
    description = "Storage account access tier update error."
    value       = step.container.update_storage_account_access_tier.stderr
  }
}
