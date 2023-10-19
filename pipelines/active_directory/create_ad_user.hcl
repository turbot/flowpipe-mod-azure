pipeline "create_ad_user" {
  title       = "Create AD User"
  description = "Create a user in Azure AD."

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

  param "user_principal_name" {
    type        = string
    description = "User Principal Name (UPN) for the new Azure AD user."
  }

  param "display_name" {
    type        = string
    description = "Display name for the new Azure AD user."
  }

  param "password" {
    type        = string
    description = "Password for the new Azure AD user."
  }

  step "container" "create_ad_user" {
    image = "my-azure-image"
    cmd   = ["ad", "user", "create", "--user-principal-name", param.user_principal_name, "--display-name", param.display_name, "--password", param.password]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stdout" {
    description = "Ad user create output."
    value       = jsondecode(step.container.create_ad_user.stdout)
  }

  output "stderr" {
    description = "Ad user create error."
    value       = step.container.create_ad_user.stderr
  }
}
