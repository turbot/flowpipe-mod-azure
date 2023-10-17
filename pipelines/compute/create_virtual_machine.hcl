pipeline "create_virtual_machine" {
  title       = "Create Virtual Machine"
  description = "Create a new virtual machine."

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
    default     = "testFlowpipe1"
  }

  param "vm_image" {
    type        = string
    description = "The OS image for the Virtual Machine."
    default     = "Ubuntu2204"
  }

  param "admin_username" {
    type        = string
    description = "The administrator username for the Virtual Machine."
    default     = "adminuser"
  }

  param "admin_password" {
    type        = string
    description = "The administrator password for the Virtual Machine."
    default     = "Admin12345578!"
  }

  param "location" {
    type        = string
    description = "The Azure region where the Virtual Machine will be deployed."
    default     = "East US"
  }

  param "vm_size" {
    type        = string
    description = "The size of the Virtual Machine."
    default     = "Standard_DS2_v2"
  }

  param "authentication_type" {
    type        = string
    description = "The authentication type for the Virtual Machine (password or ssh)."
    default     = "password"
  }

  param "network_security_group" {
    type        = string
    description = "The name of the Network Security Group for the Virtual Machine."
    default     = "testFlowpipe-nsg"
  }

  step "container" "create_virtual_machine" {
    image = "my-azure-image"
    cmd = [
      "vm", "create",
      "-g", param.resource_group,
      "-n", param.vm_name,
      "--image", param.vm_image,
      "--admin-username", param.admin_username,
      "--admin-password", param.admin_password,
      "--location", param.location,
      "--size", param.vm_size,
      "--authentication-type", param.authentication_type,
      "--nsg", param.network_security_group,
    ]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "vm_out" {
    description = "VM details."
    value       = step.container.create_virtual_machine.stdout
  }

  output "vm_err" {
    description = "VM error."
    value       = step.container.create_virtual_machine.stderr
  }
}
