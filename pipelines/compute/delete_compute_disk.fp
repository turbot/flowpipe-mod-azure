pipeline "delete_compute_disk" {
  title       = "Delete Compute Disk"
  description = "Delete a managed disk."

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
    default     = var.subscription_id
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

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
    default     = var.resource_group
  }

  param "disk_name" {
    type        = string
    description = "The name of the Disk."
  }

  step "container" "delete_compute_disk" {
    image = "my-azure-image"
    cmd   = ["disk", "delete", "--yes", "-g", param.resource_group, "-n", param.disk_name, "--subscription", param.subscription_id]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "disk" {
    description = "The deleted compute disk details."
    value       = jsondecode(step.container.delete_compute_disk.stdout)
  }
}
