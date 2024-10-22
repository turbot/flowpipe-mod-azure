pipeline "set_key_vault_secret_attributes" {
  title       = "Set Key Vault Secret Attributes"
  description = "Set attributes for a secret in the specified Azure Key Vault."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "vault_name" {
    type        = string
    description = "The Azure Key Vault name."
  }

  param "secret_name" {
    type        = string
    description = "The name of the secret in the key vault."
  }

  param "expires" {
    type        = string
    description = "The expiry date and time for the secret in the format Y-m-d'T'H:M:S'Z'."
  }

  step "container" "set_key_vault_secret_attributes" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "keyvault", "secret", "set-attributes",
      "--name", param.secret_name,
      "--vault-name", param.vault_name,
      "--expires", param.expires,
      "--subscription", param.subscription_id
    ]

    env = param.conn.env
  }

  output "secret_attributes" {
    description = "The updated secret attributes."
    value       = jsondecode(step.container.set_key_vault_secret_attributes.stdout)
  }
}
