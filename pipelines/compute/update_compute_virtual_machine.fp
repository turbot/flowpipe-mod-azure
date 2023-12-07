pipeline "update_compute_virtual_machine" {
  title       = "Update Compute Virtual Machine"
  description = "Update the properties of a VM."

  tags = {
    type = "featured"
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

  param "set_tags" {
    type        = map
    description = "The Virtual Machine Tags which are need to be set or update. Example tagKey:tagValue."
    optional    = true
  }

  param "license_type" {
    type        = string
    description = "The license type of the Virtual Machine."
    optional    = true
  }

  step "container" "update_compute_virtual_machine" {
    image = "my-azure-image"
    cmd = concat(
      ["vm", "update", "-g", param.resource_group, "-n", param.vm_name, "--subscription", param.subscription_id],
      param.set_tags != null ? concat(["--set"], [for key, value in param.set_tags : "tags.${key}=${value}"]) : [],
      param.license_type != null ? concat(["--license-type", param.license_type]) : [],
    )

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "virtual_machine" {
    description = "The updated compute virtual machine."
    value       = jsondecode(step.container.update_compute_virtual_machine.stdout)
  }
}
