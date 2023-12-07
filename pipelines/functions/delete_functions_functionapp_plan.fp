pipeline "delete_functions_functionapp_plan" {
  title       = "Delete Functions Functionapp Plan"
  description = "Delete an App Service Plan."

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

  param "plan_name" {
    type        = string
    description = "The name of the app service plan."
  }

  step "container" "delete_functions_functionapp_plan" {
    image = "my-azure-image"
    cmd   = ["functionapp", "plan", "delete", "--yes", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.plan_name]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "app_plan" {
    description = "The deleted app service plan details."
    value       = jsondecode(step.container.delete_functions_functionapp_plan.stdout)
  }
}
