pipeline "create_functions_functionapp_plan" {
  title       = "Create Functions Functionapp Plan"
  description = "Create an App Service Plan for an Azure Function."

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

  param "sku" {
    type        = string
    description = "The SKU of the app service plan."
  }

  step "container" "create_functions_functionapp_plan" {
    image = "my-azure-image"
    cmd   = ["functionapp", "plan", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.plan_name, "--sku", param.sku]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "app_plan" {
    description = "The created app service plan details."
    value       = jsondecode(step.container.create_functions_functionapp_plan.stdout)
  }
}