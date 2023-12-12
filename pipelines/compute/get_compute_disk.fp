pipeline "get_compute_disk" {
  title       = "Get Compute Disk"
  description = "Get information about a disk."

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
    description = "The name of the Disk."
  }

  step "container" "get_compute_disk" {
    image = "my-azure-image"
    cmd   = ["disk", "show", "-g", param.resource_group, "-n", param.disk_name, "--subscription", param.subscription_id]

    env = credential.azure[param.cred].env
  }

  output "disk" {
    description = "The compute disk details."
    value       = jsondecode(step.container.get_compute_disk.stdout)
  }
}
