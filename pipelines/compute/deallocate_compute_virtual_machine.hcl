pipeline "deallocate_compute_virtual_machine" {
  title       = "Deallocate Compute Virtual Machine"
  description = "Deallocate a VM so that computing resources are no longer allocated (charges no longer apply). The status will change from Stopped to Stopped (Deallocated)."

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
    default     = var.subscription_id
    # TODO: Add once supported
    #sensitive   = true
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
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
    # TODO: Add once supported
    #sensitive   = true
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

  output "stdout" {
    description = "The standard output stream from the Azure CLI."
    # When the VM is deallocated, the standard output (stdout) becomes an empty string.
    # Therefore, this situation deviates from the usual practice of utilizing jsondecode.
    value = step.container.deallocate_compute_virtual_machine.stdout
  }

  output "stderr" {
    description = "The standard error stream from the Azure CLI."
    value       = step.container.deallocate_compute_virtual_machine.stderr
  }
}
