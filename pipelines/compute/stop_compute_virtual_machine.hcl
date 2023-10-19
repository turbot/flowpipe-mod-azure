pipeline "stop_compute_virtual_machine" {
  title       = "Stop Compute Virtual Machine"
  description = "Power off (stop) a running VM."

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

  step "container" "stop_compute_virtual_machine" {
    image = "my-azure-image"
    cmd   = ["vm", "stop", "-g", param.resource_group, "-n", param.vm_name, "--subscription", param.subscription_id]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stdout" {
    description = "Compute VM stop output."
    value       = jsondecode(step.container.stop_compute_virtual_machine.stdout)
  }

  output "stderr" {
    description = "Compute VM stop error."
    value       = step.container.stop_compute_virtual_machine.stderr
  }
}
