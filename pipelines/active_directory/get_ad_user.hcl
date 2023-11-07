pipeline "get_ad_user" {
  title       = "Get AD User"
  description = "Get a user in Azure AD."

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

  step "container" "get_ad_user" {
    image = "my-azure-image"
    cmd   = ["ad", "user", "show", "--id", param.user_id]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "user" {
    description = "AzureAD user details."
    value       = jsondecode(step.container.get_ad_user.stdout)
  }

  output "stderr" {
    description = "Ad user get error."
    value       = step.container.get_ad_user.stderr
  }
}