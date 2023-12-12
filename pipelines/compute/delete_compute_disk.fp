pipeline "delete_compute_disk" {
  title       = "Delete Compute Disk"
  description = "Delete a managed disk."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
    default     = var.subscription_id
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
    default     = var.resource_group
  }

  param "disk_name" {
    type        = string
    description = "The name of the managed disk that is being deleted."
  }

  step "container" "delete_compute_disk" {
    image = "my-azure-image"
    cmd   = ["disk", "delete", "--yes", "-g", param.resource_group, "-n", param.disk_name, "--subscription", param.subscription_id]

    env = credential.azure[param.cred].env
  }

  output "disk" {
    description = "The deleted compute disk details."
    value       = jsondecode(step.container.delete_compute_disk.stdout)
  }
}
