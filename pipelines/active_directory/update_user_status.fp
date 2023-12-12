pipeline "update_user_status" {
  title       = "Disable or Enable AD User"
  description = "Update user account status in Azure AD."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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

    env = credential.azure[param.cred].env
  }
}
