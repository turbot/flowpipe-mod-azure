pipeline "attach_compute_disk" {
  title       = "Attach Compute Disk"
  description = "Attach a managed persistent disk to a VM."

  param "subscription_id" {
    type        = string
    description = "Azure Subscription Id."
    default     = var.subscription_id
    # TODO: Add once supported
    #sensitive   = true
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

  param "disk_name" {
    type        = string
    description = "The name of the Disk."
  }

  step "container" "attach_compute_disk" {
    image = "my-azure-image"
    cmd   = ["vm", "disk", "attach", "--vm-name", param.vm_name, "-g", param.resource_group, "-n", param.disk_name, "--subscription", param.subscription_id]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stdout" {
    description = "Disk output."
    value       = jsondecode(step.container.attach_compute_disk.stdout)
  }

  output "stderr" {
    description = "Disk error."
    value       = step.container.attach_compute_disk.stderr
  }
}