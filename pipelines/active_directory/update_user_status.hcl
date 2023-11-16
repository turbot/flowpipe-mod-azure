pipeline "update_user_status" {
  title       = "Disable or Enable AD User"
  description = "Update user account status in Azure AD."

  param "tenant_id" {
    type        = string
    description = local.tenant_id_param_description
    default     = var.tenant_id
    # TODO: Add once supported
    # sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
    # TODO: Add once supported
    # sensitive   = true
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
    # TODO: Add once supported
    # sensitive   = true
  }

  param "user_id" {
    type        = string
    description = "The object ID or principal name of the user for which to get information."
  }

  param "account_enabled" {
    type        = string
    description = "User account status. The allowed values are false: to disable user, true: to enable user."
  }

  step "container" "update_user_status" {
    image = "my-azure-image"
    cmd   = ["ad", "user", "update", "--id", param.user_id, "--account-enabled", param.account_enabled]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stdout" {
    description = "The standard output stream from the Azure CLI."
    value       = step.container.update_user_status.stdout
  }

  output "stderr" {
    description = "The standard error stream from the Azure CLI."
    value       = step.container.update_user_status.stderr
  }
}
