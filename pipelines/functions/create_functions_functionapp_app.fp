pipeline "create_functions_functionapp_app" {
  title       = "Create Functions Functionapp App"
  description = "Create a function app."

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
    description = "Name of the new function app."
  }

  param "storage_account" {
    type        = string
    description = "Provide a string value of a Storage Account in the provided Resource Group. Or Resource ID of a Storage Account in a different Resource Group."
  }

  param "consumption_plan_location" {
    type        = string
    description = "Geographic location where function app will be hosted."
    optional    = true
  }

  param "runtime" {
    type        = string
    description = "The functions runtime stack."
    optional    = true
  }

  step "container" "create_functions_functionapp_app" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = concat(["functionapp", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.app_name, "-s", param.storage_account],
      param.consumption_plan_location != null ? concat(["--c", param.consumption_plan_location]) : [],
      param.runtime != null ? concat(["--runtime", param.runtime]) : [],
    )

    env = credential.azure[param.cred].env
  }

  output "app" {
    description = "The created function app details."
    value       = jsondecode(step.container.create_functions_functionapp_app.stdout)
  }
}
