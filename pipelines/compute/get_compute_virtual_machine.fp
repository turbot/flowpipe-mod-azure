pipeline "get_compute_virtual_machine" {
  title       = "Get Compute Virtual Machine"
  description = "Get the details of a VM."

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

  step "container" "get_compute_virtual_machine" {
    image = "my-azure-image"
    cmd   = ["vm", "show", "-g", param.resource_group, "-n", param.vm_name, "--subscription", param.subscription_id]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "virtual_machine" {
    description = "The compute virtual machine details."
    value       = jsondecode(step.container.get_compute_virtual_machine.stdout)
  }
}
