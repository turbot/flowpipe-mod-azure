pipeline "delete_app_service_plan" {
  title       = "Delete App Service Plan"
  description = "Delete an Azure App Service Plan."

  param "cred" {
    type        = string
    description = "The credentials to use for authentication."
    default     = "default"
  }

  param "subscription_id" {
    type        = string
    description = "The Azure subscription ID."
		default     = "d46d7416-f95f-4771-bbb5-529d4c76659c"
  }

  param "resource_group" {
    type        = string
    description = "The name of the resource group that contains the App Service Plan."
		default     = "demo"
  }

  param "service_plan_name" {
    type        = string
    description = "The name of the App Service Plan that is being deleted."
		default     = "demo9"
  }

  step "container" "delete_app_service_plan" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["appservice", "plan", "delete", "--yes", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.service_plan_name]

    env = credential.azure[param.cred].env
  }
}
