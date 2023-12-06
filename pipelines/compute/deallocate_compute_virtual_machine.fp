pipeline "deallocate_compute_virtual_machine" {
  title       = "Deallocate Compute Virtual Machine"
  description = "Deallocate a VM so that computing resources are no longer allocated (charges no longer apply). The status will change from Stopped to Stopped (Deallocated)."

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

  param "tenant_id" {
    type        = string
    description = local.tenant_id_param_description
    default     = var.tenant_id
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
  }

  step "container" "deallocate_compute_virtual_machine" {
    image = "my-azure-image"
    cmd   = ["vm", "deallocate", "-g", param.resource_group, "-n", param.vm_name, "--subscription", param.subscription_id]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "compute_virtual_machine" {
    description = "The deallocated compute virtual machine details."
    value       = step.container.deallocate_compute_virtual_machine.stdout
  }
}
