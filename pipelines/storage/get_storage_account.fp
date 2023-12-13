pipeline "get_storage_account" {
  title       = "Get Storage Account"
  description = "Show storage account properties."

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

  step "container" "get_storage_account" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["storage", "account", "show", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.account_name]

    env = credential.azure[param.cred].env
  }

  output "account" {
    description = "The storage account details."
    value       = jsondecode(step.container.get_storage_account.stdout)
  }
}
