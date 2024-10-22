pipeline "update_compute_virtual_machine" {
  title       = "Update Compute Virtual Machine"
  description = "Update the properties of a VM."

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
    description = "The name of the Virtual Machine."
  }

  param "set_tags" {
    type        = map
    description = "The Virtual Machine Tags which are need to be set or update. Example tagKey:tagValue."
    optional    = true
  }

  param "license_type" {
    type        = string
    description = "Specifies that the Windows image or disk was licensed on-premises."
    optional    = true
  }

  step "container" "update_compute_virtual_machine" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = concat(
      ["vm", "update", "-g", param.resource_group, "-n", param.vm_name, "--subscription", param.subscription_id],
      param.set_tags != null ? concat(["--set"], [for key, value in param.set_tags : "tags.${key}=${value}"]) : [],
      param.license_type != null ? concat(["--license-type", param.license_type]) : [],
    )

    env = param.conn.env
  }

  output "virtual_machine" {
    description = "The updated compute virtual machine."
    value       = jsondecode(step.container.update_compute_virtual_machine.stdout)
  }
}
