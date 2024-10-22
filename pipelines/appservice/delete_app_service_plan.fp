pipeline "delete_app_service_plan" {
  title       = "Delete App Service Plan"
  description = "Delete an Azure App Service Plan."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "subscription_id" {
    type        = string
    description = "The Azure subscription ID."
  }

  param "resource_group" {
    type        = string
    description = "The name of the resource group that contains the App Service Plan."
  }

  param "service_plan_name" {
    type        = string
    description = "The name of the App Service Plan that is being deleted."
  }

  step "container" "delete_app_service_plan" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["appservice", "plan", "delete", "--yes", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.service_plan_name]

    env = param.conn.env
  }
}
