pipeline "update_azure_key_vault_purge_protection" {
  title       = "Update Azure Key Vault Purge Protection"
  description = "Enable or disable purge protection for the specified Azure Key Vault."

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

  param "vault_name" {
    type        = string
    description = "The Azure Key Vault name."
  }

  param "enable_purge_protection" {
    type        = bool
    description = "Enable or disable purge protection for the key vault."
  }

  step "container" "update_key_vault_purge_protection" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = concat(
      ["keyvault", "update", "--resource-group", param.resource_group, "--subscription", param.subscription_id, "--name", param.vault_name],
      param.enable_purge_protection ? ["--enable-purge-protection", "true"] : ["--enable-purge-protection", "false"]
    )

    env = param.conn.env
  }

  output "key_vault" {
    description = "The updated Azure Key Vault."
    value       = jsondecode(step.container.update_key_vault_purge_protection.stdout)
  }
}
