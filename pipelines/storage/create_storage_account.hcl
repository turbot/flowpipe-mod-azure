pipeline "create_storage_account" {
  title       = "Create Storage Account"
  description = "Create a storage account."

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
    default     = var.subscription_id
    # TODO: Add once supported
    #sensitive   = true
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
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "account_name" {
    type        = string
    description = "The storage account name."
  }

  param "location" {
    type        = string
    description = "The storage account location."
    optional    = true
  }

  param "sku" {
    type        = string
    description = "The storage account SKU."
    optional    = true
  }

  step "container" "create_storage_account" {
    image = "my-azure-image"
    cmd = concat(
      ["storage", "account", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.account_name],
      param.location != null ? concat(["-l", param.location]) : [],
      param.sku != null ? concat(["--sku", param.sku]) : []
    )

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stdout" {
    description = "The standard output stream from the Azure CLI."
    value       = jsondecode(step.container.create_storage_account.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the Azure CLI."
    value       = step.container.create_storage_account.stderr
  }
}
