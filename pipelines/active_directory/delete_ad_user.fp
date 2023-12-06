pipeline "delete_ad_user" {
  title       = "Delete AD User"
  description = "Delete a user from the directory."

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

  step "container" "delete_ad_user" {
    image = "my-azure-image"
    cmd   = ["ad", "user", "delete", "--id", param.user_id]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "ad_user" {
    description = "Information about the deleted AD User."
    value       = step.container.delete_ad_user.stdout
  }
}
