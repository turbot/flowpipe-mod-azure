pipeline "delete_ad_group" {
  title       = "Delete AD Group"
  description = "Delete a group from the directory."

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
}
