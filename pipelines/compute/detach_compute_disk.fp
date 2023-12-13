pipeline "detach_compute_disk" {
  title       = "Detach Compute Disk"
  description = "Detach a managed disk from a VM."

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

  param "vm_name" {
    type        = string
    description = "The name of the Virtual Machine."
  }

  param "disk_name" {
    type        = string
    description = "The data disk name."
  }

  step "container" "detach_compute_disk" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["vm", "disk", "detach", "--vm-name", param.vm_name, "-g", param.resource_group, "-n", param.disk_name, "--subscription", param.subscription_id]

    env = credential.azure[param.cred].env
  }

  output "disk" {
    description = "The detached compute disk details."
    value       = jsondecode(step.container.detach_compute_disk.stdout)
  }
}
