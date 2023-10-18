pipeline "create_functions_functionapp_app" {
  title       = "Create Functions Functionapp App"
  description = "Create a function app."

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

  output "stdout" {
    description = "Function app details."
    value       = step.container.create_functions_functionapp_app.stdout
  }

  output "stderr" {
    description = "Function app error."
    value       = step.container.create_functions_functionapp_app.stderr
  }
}
