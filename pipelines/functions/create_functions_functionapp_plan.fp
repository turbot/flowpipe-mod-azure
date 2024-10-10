pipeline "create_functions_functionapp_plan" {
  title       = "Create Functions Functionapp Plan"
  description = "Create an App Service Plan for an Azure Function."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
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
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["functionapp", "plan", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.plan_name, "--sku", param.sku]

    env = param.conn.env
  }

  output "app_plan" {
    description = "The created app service plan details."
    value       = jsondecode(step.container.create_functions_functionapp_plan.stdout)
  }
}
