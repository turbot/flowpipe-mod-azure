pipeline "create_resource_group" {
  title       = "Create Resource Group"
  description = "Create a resource group in Azure."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "resource_group" {
    type        = string
    description = "The name of the resource group to create."
  }

  param "region" {
    type        = string
    description = "The Azure region in which to create the resource group."
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  step "container" "create_resource_group" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "group", "create",
      "--name", param.resource_group,
      "--location", param.region,
      "--subscription", param.subscription_id
    ]

    env = param.conn.env
  }

  output "resource_group" {
    description = "The details of the created resource group."
    value       = jsondecode(step.container.create_resource_group.stdout)
  }
}
