pipeline "create_storage_account" {
  title       = "Create Storage Account"
  description = "Create a storage account."

  tags = {
    recommended = "true"
  }

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
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = concat(
      ["storage", "account", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.account_name],
      param.location != null ? concat(["-l", param.location]) : [],
      param.sku != null ? concat(["--sku", param.sku]) : []
    )

    env = param.conn.env
  }

  output "account" {
    description = "The created storage account details."
    value       = jsondecode(step.container.create_storage_account.stdout)
  }
}
