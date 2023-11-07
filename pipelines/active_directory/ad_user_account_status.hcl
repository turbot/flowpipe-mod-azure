pipeline "ad_user_account_status" {
  title       = "Disable or Enable AD User"
  description = "Update user account status in Azure AD."

  param "tenant_id" {
    type        = string
    description = "The Microsoft Entra ID tenant (directory) ID."
    default     = var.tenant_id
    # TODO: Add once supported
    # sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = "A client secret that was generated for the App Registration."
    default     = var.client_secret
    # TODO: Add once supported
    # sensitive   = true
  }

  param "client_id" {
    type        = string
    description = "The client (application) ID of an App Registration in the tenant."
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
    description = "User account status."
  }

  step "container" "ad_user_account_status" {
    image = "my-azure-image"
    cmd   = ["ad", "user", "update", "--id", param.user_id, "--account-enabled", param.account_enabled]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stderr" {
    description = "AD user update error."
    value       = step.container.ad_user_account_status.stderr
  }
}
