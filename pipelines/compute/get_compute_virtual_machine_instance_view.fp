pipeline "get_compute_virtual_machine_instance_view" {
  title       = "Get Compute Virtual Machine Instance View"
  description = "Get instance information about a VM."

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

  step "container" "get_compute_virtual_machine_instance_view" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["vm", "get-instance-view", "--name", param.vm_name, "-g", param.resource_group, "--subscription", param.subscription_id]

    env = credential.azure[param.cred].env
  }

  output "instance_view" {
    description = "The compute virtual machine instance view."
    value       = jsondecode(step.container.get_compute_virtual_machine_instance_view.stdout)
  }
}
