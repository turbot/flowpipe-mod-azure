pipeline "deallocate_compute_virtual_machine" {
  title       = "Deallocate Compute Virtual Machine"
  description = "Deallocate a VM so that computing resources are no longer allocated (charges no longer apply). The status will change from Stopped to Stopped (Deallocated)."

  param "subscription_id" {
    type        = string
    description = "Azure Subscription Id."
    default     = var.subscription_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "resource_group" {
    type        = string
    description = "Azure Resource Group."
    default     = var.resource_group
    # TODO: Add once supported
    #sensitive   = true
  }

  param "vm_name" {
    type        = string
    description = "The name of the Virtual Machine."
  }

  param "tenant_id" {
    type        = string
    description = "The Microsoft Entra ID tenant (directory) ID."
    default     = var.tenant_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = "A client secret that was generated for the App Registration."
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = "The client (application) ID of an App Registration in the tenant."
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
    description = "VM details."
    value       = step.container.deallocate_compute_virtual_machine.stdout
  }

  output "stderr" {
    description = "VM error."
    value       = step.container.deallocate_compute_virtual_machine.stderr
  }
}
