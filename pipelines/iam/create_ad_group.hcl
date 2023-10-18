pipeline "create_ad_group" {
  title       = "Create AD Group"
  description = "Create a group in the directory."

  param "tenant_id" {
    type        = string
    description = "The Microsoft Entra ID tenant (directory) ID."
    default     = var.tenant_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = "A client secret that was generated for the App Registration."
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = "The client (application) ID of an App Registration in the tenant."
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
    description = "Group output."
    value       = jsondecode(step.container.create_ad_group.stdout)
  }

  output "stderr" {
    description = "Group error."
    value       = step.container.create_ad_group.stderr
  }
}
