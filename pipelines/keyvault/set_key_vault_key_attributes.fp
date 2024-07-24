
pipeline "set_key_vault_key_attributes" {
  title       = "Set Key Vault Key Attributes"
  description = "Set attributes for a key in the specified Azure Key Vault."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "vault_name" {
    type        = string
    description = "The Azure Key Vault name."
  }

  param "key_name" {
    type        = string
    description = "The name of the key in the key vault."
  }

  param "expires" {
    type        = string
    description = "The expiry date and time for the key in the format Y-m-d'T'H:M:S'Z'."
  }

  step "container" "set_key_vault_key_attributes" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "keyvault", "key", "set-attributes",
      "--name", param.key_name,
      "--vault-name", param.vault_name,
      "--expires", param.expires,
      "--subscription", param.subscription_id
    ]

    env = credential.azure[param.cred].env
  }

  output "key_attributes" {
    description = "The updated key attributes."
    value       = jsondecode(step.container.set_key_vault_key_attributes.stdout)
  }
}
