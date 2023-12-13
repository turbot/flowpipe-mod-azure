pipeline "list_compute_virtual_machines" {
  title       = "List Compute Virtual Machines"
  description = "List details of Virtual Machines."

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

  step "container" "list_compute_virtual_machines" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["vm", "list", "-g", param.resource_group, "--subscription", param.subscription_id]

    env = credential.azure[param.cred].env
  }

  output "virtual_machines" {
    description = "List of compute virtual machines."
    value       = jsondecode(step.container.list_compute_virtual_machines.stdout)
  }
}
