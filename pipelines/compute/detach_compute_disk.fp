pipeline "detach_compute_disk" {
  title       = "Detach Compute Disk"
  description = "Detach a managed disk from a VM."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
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
    description = "The data disk name."
  }

  step "container" "detach_compute_disk" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["vm", "disk", "detach", "--vm-name", param.vm_name, "-g", param.resource_group, "-n", param.disk_name, "--subscription", param.subscription_id]

    env = param.conn.env
  }

  output "disk" {
    description = "The detached compute disk details."
    value       = jsondecode(step.container.detach_compute_disk.stdout)
  }
}
