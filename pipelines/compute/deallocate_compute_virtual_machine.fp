pipeline "deallocate_compute_virtual_machine" {
  title       = "Deallocate Compute Virtual Machine"
  description = "Deallocate a VM so that computing resources are no longer allocated (charges no longer apply). The status will change from Stopped to Stopped (Deallocated)."

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

  step "container" "deallocate_compute_virtual_machine" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["vm", "deallocate", "-g", param.resource_group, "-n", param.vm_name, "--subscription", param.subscription_id]

    env = param.conn.env
  }
}
