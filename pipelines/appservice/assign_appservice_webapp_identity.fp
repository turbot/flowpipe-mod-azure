pipeline "assign_appservice_webapp_identity" {
  title       = "Assign Managed Identity to AppService Web App"
  description = "Assign a managed identity to an Azure AppService Web App."

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

  param "app_name" {
    type        = string
    description = "Name of the AppService web app."
  }

  step "container" "assign_appservice_webapp_identity" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = [
      "webapp", "identity", "assign",
      "--resource-group", param.resource_group,
      "--name", param.app_name
    ]

    env = param.conn.env
  }

  output "assign_appservice_webapp_identity" {
    description = "The assigned managed identity for the web app."
    value       = jsondecode(step.container.assign_appservice_webapp_identity.stdout)
  }
}
