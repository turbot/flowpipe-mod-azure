pipeline "update_appservice_webapp_auth" {
  title       = "Update AppService Web App Authentication"
  description = "Update the authentication settings of an Azure Web App."

  tags = {
    type = "featured"
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

  param "enabled" {
    type        = bool
    description = "Enable or disable authentication for the web app."
  }

  step "container" "update_appservice_webapp_auth" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = concat(
      ["webapp", "auth", "update", "--resource-group", param.resource_group, "--name", param.app_name, "--enabled", tostring(param.enabled)]
    )

    env = param.conn.env
  }

  output "webapp_auth" {
    description = "The updated web app authentication settings."
    value       = jsondecode(step.container.update_appservice_webapp_auth.stdout)
  }
}
