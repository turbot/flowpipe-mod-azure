pipeline "update_ad_user" {
  title       = "Update AD User"
  description = "Update a user in Azure AD."

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

  param "user_id" {
    type        = string
    description = "The object ID or principal name of the user for which to get information."
  }

  param "display_name" {
    type        = string
    description = "Display name for the new Azure AD user."
    optional    = true
  }

  step "container" "update_ad_user" {
    image = "my-azure-image"
    cmd   = ["ad", "user", "update", "--id", param.user_id, "--display-name", param.display_name]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "user" {
    description = "Updated AD user details."
    value       = jsondecode(step.container.update_ad_user.stdout)
  }
}
