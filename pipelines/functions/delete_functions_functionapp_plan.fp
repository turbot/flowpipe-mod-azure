pipeline "delete_functions_functionapp_plan" {
  title       = "Delete Functions Functionapp Plan"
  description = "Delete an App Service Plan."

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "plan_name" {
    type        = string
    description = "The name of the app service plan."
  }

  step "container" "delete_functions_functionapp_plan" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["functionapp", "plan", "delete", "--yes", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.plan_name]

    env = credential.azure[param.cred].env
  }

  output "app_plan" {
    description = "The deleted app service plan details."
    value       = jsondecode(step.container.delete_functions_functionapp_plan.stdout)
  }
}
