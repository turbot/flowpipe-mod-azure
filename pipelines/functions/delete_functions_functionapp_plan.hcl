pipeline "delete_functions_functionapp_plan" {
  title       = "Delete Functions Functionapp Plan"
  description = "Delete an App Service Plan."

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

  step "container" "delete_functions_functionapp_plan" {
    image = "my-azure-image"
    cmd   = ["functionapp", "plan", "delete", "--yes", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.plan_name]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stdout" {
    description = "Function plan output."
    value       = jsondecode(step.container.delete_functions_functionapp_plan.stdout)
  }

  output "stderr" {
    description = "Function plan error."
    value       = step.container.delete_functions_functionapp_plan.stderr
  }
}