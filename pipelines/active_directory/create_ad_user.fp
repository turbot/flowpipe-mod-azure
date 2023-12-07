pipeline "create_ad_user" {
  title       = "Create AD User"
  description = "Create a user in Azure AD."

  tags = {
    type = "featured"
  }

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

  output "user" {
    description = "Information about the created AD User."
    value       = jsondecode(step.container.create_ad_user.stdout)
  }
}
