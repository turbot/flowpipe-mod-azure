pipeline "attach_compute_disk" {
  title       = "Attach Compute Disk"
  description = "Attach a managed persistent disk to a VM."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
  }

  param "vm_name" {
    type        = string
    description = "The name of the Virtual Machine."
  }

  param "disk_name" {
    type        = string
    description = "The name or ID of the managed disk."
  }

  step "container" "attach_compute_disk" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["vm", "disk", "attach", "--vm-name", param.vm_name, "-g", param.resource_group, "-n", param.disk_name, "--subscription", param.subscription_id]

    env = credential.azure[param.cred].env
  }

  output "disk" {
    description = "Attached compute disk details."
    value       = jsondecode(step.container.attach_compute_disk.stdout)
  }
}
