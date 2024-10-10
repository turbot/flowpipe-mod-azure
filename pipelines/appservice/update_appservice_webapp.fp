pipeline "update_appservice_webapp" {
  title       = "Update AppService Web App"
  description = "Update setting for an Azure Web App."

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
    description = "Name of the web app."
  }

  param "https_only" {
    type        = bool
    description = "Enable or disable HTTPS only for the web app."
  }

  step "container" "update_appservice_webapp" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = [
      "webapp", "update",
      "--resource-group", param.resource_group,
      "--name", param.app_name,
      "--set", "httpsOnly=${param.https_only}"
    ]

    env = param.conn.env
  }

  output "update_appservice_webapp" {
    description = "The updated setting for the web app."
    value       = jsondecode(step.container.update_appservice_webapp.stdout)
  }
}
