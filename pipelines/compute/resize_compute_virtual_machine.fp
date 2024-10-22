pipeline "resize_compute_virtual_machine" {
  title       = "Resize Compute Virtual Machine"
  description = "Resize the properties of a VM."

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

  param "new_size" {
    type        = string
    description = "The new size for the Virtual Machine."
  }

  step "container" "resize_compute_virtual_machine" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = [
      "vm", "resize",
      "-g", param.resource_group,
      "-n", param.vm_name,
      "--subscription", param.subscription_id,
      "--size", param.new_size
    ]

    env = param.conn.env
  }

  output "virtual_machine" {
    description = "The resized compute virtual machine."
    value       = jsondecode(step.container.resize_compute_virtual_machine.stdout)
  }
}
