pipeline "show_disk" {
  title       = "Show Disk"
  description = "Show a disk."

  param "subscription_id" {
    type        = string
    description = "Azure Subscription Id."
    default     = var.subscription_id
    # TODO: Add once supported
    #sensitive   = true
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

  param "resource_group" {
    type        = string
    description = "Azure Resource Group."
    default     = var.resource_group
    # TODO: Add once supported
    #sensitive   = true
  }

  param "disk_name" {
    type        = string
    description = "The name of the Disk."
    default     = "test-flowpipe-disk"
  }

  step "container" "show_disk" {
    image = "my-azure-image"
    cmd   = ["disk", "show", "-g", param.resource_group, "-n", param.disk_name, "--subscription", param.subscription_id]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "disk_out" {
    description = "Disk details."
    value       = step.container.show_disk.stdout
  }

  output "disk_err" {
    description = "Disk error."
    value       = step.container.show_disk.stderr
  }
}
