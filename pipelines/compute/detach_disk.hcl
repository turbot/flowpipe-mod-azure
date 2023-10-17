pipeline "detach_disk" {
  title       = "Detach Disk From Virtual Machine"
  description = "Detach a disk from a VM."

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

  param "vm_name" {
    type        = string
    description = "The name of the VM."
    default     = "testFlowpipe"
  }

  param "disk_name" {
    type        = string
    description = "The name of the Disk."
    default     = "test-flowpipe-disk"
  }

  step "container" "attach_disk" {
    image = "my-azure-image"
    cmd   = ["vm", "disk", "detach", "--vm-name", param.vm_name, "-g", param.resource_group, "-n", param.disk_name, "--subscription", param.subscription_id]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "disk_out" {
    description = "Disk details."
    value       = step.container.detach_disk.stdout
  }

  output "disk_err" {
    description = "Disk error."
    value       = step.container.detach_disk.stderr
  }
}
