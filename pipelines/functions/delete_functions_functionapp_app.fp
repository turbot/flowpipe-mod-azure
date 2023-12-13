pipeline "delete_functions_functionapp_app" {
  title       = "Delete Functions Functionapp App"
  description = "Delete a function app."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
    default     = var.subscription_id
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
    default     = var.resource_group
  }

  param "app_name" {
    type        = string
    description = "The name of the functionapp."
  }

  step "container" "delete_functions_functionapp_app" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["functionapp", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.app_name]

    env = credential.azure[param.cred].env
  }

  output "app" {
    description = "The deleted function app details."
    value       = jsondecode(step.container.delete_functions_functionapp_app.stdout)
  }
}
