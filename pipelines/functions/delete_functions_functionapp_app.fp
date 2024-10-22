pipeline "delete_functions_functionapp_app" {
  title       = "Delete Functions Functionapp App"
  description = "Delete a function app."

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
    description = "The name of the functionapp."
  }

  step "container" "delete_functions_functionapp_app" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["functionapp", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.app_name]

    env = param.conn.env
  }

  output "app" {
    description = "The deleted function app details."
    value       = jsondecode(step.container.delete_functions_functionapp_app.stdout)
  }
}
