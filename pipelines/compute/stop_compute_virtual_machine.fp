pipeline "stop_compute_virtual_machine" {
  title       = "Stop Compute Virtual Machine"
  description = "Power off (stop) a running VM."

  tags = {
    recommended = "true"
  }

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

  step "container" "stop_compute_virtual_machine" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["vm", "stop", "-g", param.resource_group, "-n", param.vm_name, "--subscription", param.subscription_id]

    env = param.conn.env
  }

  output "virtual_machine" {
    description = "The stopped compute virtual machine."
    value       = jsondecode(step.container.stop_compute_virtual_machine.stdout)
  }
}
