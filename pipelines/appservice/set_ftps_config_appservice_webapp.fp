pipeline "set_config_appservice_webapp" {
  title       = "Set Configuration for AppService Web App"
  description = "Set the configuration for an Azure Web App."

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

  param "python_version" {
    type        = string
    description = "Python version to use for the web app."
    optional    = true
  }

  param "windows_fx_version" {
    type        = string
    description = "Windows FX version for web app."
    optional    = true
  }

  param "linux_fx_version" {
    type        = string
    description = "Linux FX version for web app."
    optional    = true
  }

  param "remote_debugging" {
    type        = bool
    description = "Enable or disable remote debugging for the web app."
    optional    = true
  }

  step "container" "set_config_appservice_webapp" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
     cmd = concat(
      ["webapp", "config", "set", "--resource-group", param.resource_group, "--name", param.app_name],
      param.python_version != null ? ["--python-version", param.python_version] : [],
      param.windows_fx_version != null ? ["--windows-fx-version", param.windows_fx_version] : [],
      param.linux_fx_version != null ? ["--linux-fx-version", param.linux_fx_version] : [],
      param.ftps_state != null ? concat(["--ftps-state", param.ftps_state]) : [],
      param.enable_http2 != null ? ["--http20-enabled", "true"] : [],
      param.tls_version != null ? concat(["--min-tls-version", param.tls_version]) : [],
      param.remote_debugging != null ? ["--remote-debugging-enabled", param.remote_debugging ? "true" : "false"] : []
    )
    env = param.conn.env
  }

  output "config_webapp" {
    description = "The updated configuration settings for the web app."
    value       = jsondecode(step.container.set_config_appservice_webapp.stdout)
  }
}
