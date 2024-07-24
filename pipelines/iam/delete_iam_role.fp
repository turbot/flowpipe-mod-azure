pipeline "delete_iam_role" {
  title       = "Delete Azure IAM Role"
  description = "Delete an Azure IAM role."

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "role_name" {
    type        = string
    description = "The name of the IAM role."
  }

  step "container" "delete_iam_role" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "role", "definition", "delete",
      "--name", param.role_name,
      "--subscription", param.subscription_id
    ]

    env = credential.azure[param.cred].env
  }

  output "iam_role" {
    description = "The deleted IAM role details."
    value       = jsondecode(step.container.delete_iam_role.stdout)
  }
}
