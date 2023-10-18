pipeline "create_functions_functionapp_plan" {
  title       = "Create Functions Functionapp Plan"
  description = "Create an App Service Plan for an Azure Function."

  param "subscription_id" {
    type        = string
    description = "Azure Subscription Id."
    default     = var.subscription_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "resource_group" {
    type        = string
    description = "Azure Resource Group."
    default     = var.resource_group
    # TODO: Add once supported
    #sensitive   = true
  }

  param "tenant_id" {
    type        = string
    description = "The Microsoft Entra ID tenant (directory) ID."
    default     = var.tenant_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = "A client secret that was generated for the App Registration."
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = "The client (application) ID of an App Registration in the tenant."
    default     = var.client_id
    # TODO: Add once supported
    #sensitive   = true
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

  output "stdout" {
    description = "Function plan output."
    value       = jsondecode(step.container.create_functions_functionapp_plan.stdout)
  }

  output "stderr" {
    description = "Function plan error."
    value       = step.container.create_functions_functionapp_plan.stderr
  }
}
