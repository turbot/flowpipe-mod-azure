pipeline "create_functions_functionapp_app" {
  title       = "Create Functions Functionapp App"
  description = "Create a function app."

  tags = {
    type = "featured"
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

  param "storage_account" {
    type        = string
    description = "Provide a string value of a Storage Account in the provided Resource Group. Or Resource ID of a Storage Account in a different Resource Group."
  }

  param "consumption_plan_location" {
    type        = string
    description = "Geographic location where function app will be hosted."
  }

  param "runtime" {
    type        = string
    description = "The functions runtime stack."
  }

  step "container" "create_functions_functionapp_app" {
    image = "my-azure-image"
    cmd   = ["functionapp", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.app_name, "-s", param.storage_account, "-c", param.consumption_plan_location, "--runtime", param.runtime]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "function_app" {
    description = "The created function app details."
    value       = step.container.create_functions_functionapp_app.stdout
  }
}
