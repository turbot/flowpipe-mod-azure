pipeline "delete_compute_virtual_machine" {
  title       = "Delete Compute Virtual Machine"
  description = "Delete a VM."

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

  step "container" "delete_compute_virtual_machine" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["vm", "delete", "--yes", "-g", param.resource_group, "-n", param.vm_name, "--subscription", param.subscription_id]

    env = credential.azure[param.cred].env
  }
}
