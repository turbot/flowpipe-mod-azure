pipeline "update_storage_account_minimum_tls" {
  title       = "Update Storage Account Minimum TLS"
  description = "The minimum TLS version to be permitted on requests to storage. The default interpretation is TLS 1.0 for this property."

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

  param "minimum_tls_version" {
    type        = string
    description = "Minimum TLS version. Accepted values: TLS1_0, TLS1_1, TLS1_2."
  }

  step "container" "update_minimum_tls" {
    image = "my-azure-image"
    cmd = concat(
      [
        "storage", "account", "update",
        "--resource-group", param.resource_group,
        "--subscription", param.subscription_id,
        "--name", param.account_name,
        "--min-tls-version", param.minimum_tls_version
      ],
    )

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "tls" {
    description = "The updated minimum TLS details."
    value       = jsondecode(step.container.update_minimum_tls.stdout)
  }
}
