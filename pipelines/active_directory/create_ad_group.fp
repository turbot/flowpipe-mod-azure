pipeline "create_ad_group" {
  title       = "Create AD Group"
  description = "Create a group in Microsoft Entra ID."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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

    env = credential.azure[param.cred].env
  }

  output "group" {
    description = "Information about the created AD Group."
    value       = jsondecode(step.container.create_ad_group.stdout)
  }
}
