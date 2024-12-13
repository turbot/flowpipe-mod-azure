pipeline "encrypt_storage_account" {
  title       = "Encrypt Storage Account"
  description = "Encrypt an Azure storage account using a specified Key Vault key."

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

  param "encryption_key_name" {
    type        = string
    description = "The name of the encryption key in Key Vault."
  }

  param "encryption_key_version" {
    type        = string
    description = "The version of the encryption key in Key Vault. Leave blank for the latest version."
  }

  param "key_vault_uri" {
    type        = string
    description = "The URI of the Key Vault where the encryption key is stored."
  }

  step "container" "encrypt_storage_account" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "storage", "account", "update",
      "--name", param.account_name,
      "--resource-group", param.resource_group,
      "--subscription", param.subscription_id,
      "--encryption-key-name", param.encryption_key_name,
      "--encryption-key-version", param.encryption_key_version,
      "--encryption-key-source", "Microsoft.Keyvault",
      "--encryption-key-vault", param.key_vault_uri
    ]

    env = param.conn.env
  }

  output "encryption_status" {
    description = "The updated encryption status of the storage account."
    value       = jsondecode(step.container.encrypt_storage_account.stdout)
  }
}
