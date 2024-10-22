pipeline "update_storage_account_public_network_access" {
  title       = "Update Storage Account Public Network Access"
  description = "Update the public network access of a storage account."

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

  param "public_network_access" {
    type        = bool
    description = "Enable or disable public network access to the storage account."
  }

  step "container" "update_storage_account_public_network_access" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = concat(
      ["storage", "account", "update", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.account_name],
      param.public_network_access == true ? ["--public-network-access", "Enabled"] : ["--public-network-access", "Disabled"]
    )

    env = param.conn.env
  }

  output "account_public_network_access" {
    description = "The updated storage account public network access details."
    value       = jsondecode(step.container.update_storage_account_public_network_access.stdout)
  }
}
