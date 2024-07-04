pipeline "set_config_appservice_webapp" {
  title       = "Set Configuration for Web App"
  description = "Set the configuration for an Azure Web App."

  tags = {
    type = "featured"
  }

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

  param "app_name" {
    type        = string
    description = "Name of the web app."
  }

  param "ftps_state" {
    type        = string
    description = "FTPS state for the web app. Accepted values: disabled, FtpsOnly."
    optional    = true
  }

  param "enable_http2" {
    type        = bool
    description = "Enable HTTP/2 for the web app."
    optional    = true
  }

  param "tls_version" {
    type        = string
    description = "The TLS version to be updated."
    optional    = true
  }

  step "container" "set_config_appservice_webapp" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
     cmd = concat(
      ["webapp", "config", "set", "--resource-group", param.resource_group, "--name", param.app_name],
      param.ftps_state != null ? concat(["--ftps-state", param.ftps_state]) : [],
      param.enable_http2 != null ? ["--http20-enabled", "true"] : [],
      param.tls_version != null ? concat(["--min-tls-version", param.tls_version]) : []
    )
    env = credential.azure[param.cred].env
  }

  output "config_webapp" {
    description = "The updated configuration settings for the web app."
    value       = jsondecode(step.container.set_config_appservice_webapp.stdout)
  }
}
