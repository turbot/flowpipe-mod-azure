pipeline "stop_compute_virtual_machine" {
  title       = "Stop Compute Virtual Machine"
  description = "Power off (stop) a running VM."

  tags = {
    type = "featured"
  }

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

  step "container" "stop_compute_virtual_machine" {
    image = "my-azure-image"
    cmd   = ["vm", "stop", "-g", param.resource_group, "-n", param.vm_name, "--subscription", param.subscription_id]

    env = credential.azure[param.cred].env
  }

  output "virtual_machine" {
    description = "The stopped compute virtual machine."
    value       = jsondecode(step.container.stop_compute_virtual_machine.stdout)
  }
}
