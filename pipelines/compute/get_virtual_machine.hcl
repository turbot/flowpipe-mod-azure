pipeline "get_virtual_machine" {
  title       = "Get Virtual Machine"
  description = "Get details of a virtual machine."

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
    default     = "testFlowpipe"
  }

  param "tenant_id" {
    type        = string
    description = "The Azure Tenant Id."
    default     = var.tenant_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = "The value of the Azure Client Secret."
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = "The Azure Client Id."
    default     = var.client_id
    # TODO: Add once supported
    #sensitive   = true
  }

  step "container" "get_virtual_machine" {
    image = "my-azure-image"
    cmd   = ["vm", "show", "-g", param.resource_group, "-n", param.vm_name, "--subscription", param.subscription_id]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "vm_out" {
    description = "VM details."
    value       = step.container.get_virtual_machine.stdout
  }

  output "vm_err" {
    description = "VM error."
    value       = step.container.get_virtual_machine.stderr
  }
}
