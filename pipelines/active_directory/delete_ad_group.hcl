pipeline "delete_ad_group" {
  title       = "Delete AD Group"
  description = "Delete a group from the directory."

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

  param "group" {
    type        = string
    description = "Group's object id or display name."
  }

  step "container" "delete_ad_group" {
    image = "my-azure-image"
    cmd   = ["ad", "group", "delete", "--group", param.group]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stdout" {
    description = "Ad group delete output."
    value       = jsondecode(step.container.delete_ad_group.stdout)
  }

  output "stderr" {
    description = "AD group delete error."
    value       = step.container.delete_ad_group.stderr
  }
}
