pipeline "delete_functions_functionapp_app" {
  title       = "Delete Functions Functionapp App"
  description = "Delete a function app."

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

  param "tenant_id" {
    type        = string
    description = local.tenant_id_param_description
    default     = var.tenant_id
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
  }

  param "app_name" {
    type        = string
    description = "Name of the new function app."
  }

  step "container" "delete_functions_functionapp_app" {
    image = "my-azure-image"
    cmd   = ["functionapp", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.app_name]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "app" {
    description = "The deleted function app details."
    value       = jsondecode(step.container.delete_functions_functionapp_app.stdout)
  }
}
