pipeline "create_compute_virtual_machine" {
  title       = "Create Virtual Machine"
  description = "Create an Azure Virtual Machine."

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

  param "vm_image" {
    type        = string
    description = "The OS image for the Virtual Machine."
  }

  param "admin_username" {
    type        = string
    description = "The administrator username for the Virtual Machine."
    optional    = true
  }

  param "admin_password" {
    type        = string
    description = "The administrator password for the Virtual Machine."
    optional    = true
  }

  param "location" {
    type        = string
    description = "The Azure region where the Virtual Machine will be deployed."
    optional    = true
  }

  param "vm_size" {
    type        = string
    description = "The size of the Virtual Machine."
    optional    = true
  }

  param "authentication_type" {
    type        = string
    description = "The authentication type for the Virtual Machine (password or ssh)."
    optional    = true
  }

  param "network_security_group_name" {
    type        = string
    description = "The name of the Network Security Group for the Virtual Machine."
    optional    = true
  }

  param "generate_ssh_keys" {
    type        = bool
    description = "Generate SSH keys for the Virtual Machine."
    optional    = true
  }

  param "no_wait" {
    type        = bool
    description = "Do not wait for the long-running operation to finish."
    optional    = true
  }

  step "container" "create_compute_virtual_machine" {
    image = "my-azure-image"
    cmd = concat(
      ["vm", "create", "-g", param.resource_group, "-n", param.vm_name, "--image", param.vm_image],
      param.admin_username != null ? concat(["--admin-username", param.admin_username]) : [],
      param.admin_password != null ? concat(["--admin-password", param.admin_password]) : [],
      param.location != null ? concat(["--location", param.location]) : [],
      param.vm_size != null ? concat(["--size", param.vm_size]) : [],
      param.authentication_type != null ? concat(["--authentication-type", param.authentication_type]) : [],
      param.generate_ssh_keys == true ? concat(["--generate-ssh-keys"]) : [],
      param.no_wait == true ? concat(["--no-wait"]) : [],
      param.network_security_group_name != null ? concat(["--nsg", param.network_security_group_name]) : [],
    )

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "compute_virtual_machine" {
    description = "The created compute virtual machine details."
    value       = step.container.create_compute_virtual_machine.stdout
  }
}
