pipeline "update_storage_account_minimum_tls" {
  title       = "Update Storage Account Minimum TLS"
  description = "Update the minimum TLS version of a storage account."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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

  param "minimum_tls_version" {
    type        = string
    description = "The minimum TLS version to be permitted on requests to storage. The default interpretation is TLS 1.0 for this property. Accepted values: TLS1_0, TLS1_1, TLS1_2."
  }

  step "container" "update_minimum_tls" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = concat(
      [
        "storage", "account", "update",
        "--resource-group", param.resource_group,
        "--subscription", param.subscription_id,
        "--name", param.account_name,
        "--min-tls-version", param.minimum_tls_version
      ],
    )

    env = credential.azure[param.cred].env
  }

  output "tls" {
    description = "The updated minimum TLS details."
    value       = jsondecode(step.container.update_minimum_tls.stdout)
  }
}
