pipeline "create_ad_group" {
  title       = "Create AD Group"
  description = "Create a group in Microsoft Entra ID."

  param "tenant_id" {
    type        = string
    description = local.tenant_id_param_description
    default     = var.tenant_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "display_name" {
    type        = string
    description = "Object's display name or its prefix."
  }

  param "mail_nickname" {
    type        = string
    description = "Mail nickname."
  }

  step "container" "create_ad_group" {
    image = "my-azure-image"
    cmd   = ["ad", "group", "create", "--display-name", param.display_name, "--mail-nickname", param.mail_nickname]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stdout" {
    description = "The standard output stream from the Azure CLI."
    value       = jsondecode(step.container.create_ad_group.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the Azure CLI."
    value       = step.container.create_ad_group.stderr
  }
}
