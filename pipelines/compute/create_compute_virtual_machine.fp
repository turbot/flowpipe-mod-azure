pipeline "create_compute_virtual_machine" {
  title       = "Create Virtual Machine"
  description = "Create an Azure Virtual Machine."

  tags = {
    recommended = "true"
  }

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
  }

  param "vm_name" {
    type        = string
    description = "Name of the virtual machine."
  }

  param "vm_image" {
    type        = string
    description = "The name of the operating system image as a URN alias, URN, custom image name or ID, custom image version ID, or VHD blob URI."
  }

  param "admin_username" {
    type        = string
    description = "Username for the VM. Default value is current username of OS."
    optional    = true
  }

  param "admin_password" {
    type        = string
    description = "Password for the VM if authentication type is 'Password'."
    optional    = true
  }

  param "location" {
    type        = string
    description = "Location in which to create VM and related resources. Default to the resource group's location."
    optional    = true
  }

  param "vm_size" {
    type        = string
    description = "The VM size to be created."
    optional    = true
  }

  param "authentication_type" {
    type        = string
    description = "Type of authentication to use with the VM."
    optional    = true
  }

  param "network_security_group_name" {
    type        = string
    description = "The name to use when creating a new Network Security Group (default) or referencing an existing one."
    optional    = true
  }

  param "generate_ssh_keys" {
    type        = bool
    description = "Generate SSH public and private key files if missing."
    optional    = true
  }

  param "no_wait" {
    type        = bool
    description = "Do not wait for the long-running operation to finish."
    optional    = true
  }

  step "container" "create_compute_virtual_machine" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
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

    env = param.conn.env
  }

  output "virtual_machine" {
    description = "The created compute virtual machine details."
    value       = jsondecode(step.container.create_compute_virtual_machine.stdout)
  }
}
