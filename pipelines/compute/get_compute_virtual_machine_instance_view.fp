pipeline "get_compute_virtual_machine_instance_view" {
  title       = "Get Compute Virtual Machine Instance View"
  description = "Get instance information about a VM."

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

  param "query" {
    type        = string
    description = "JMESPath query string."
    optional    = true
  }

  step "container" "get_compute_virtual_machine_instance_view" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"

    cmd = concat(
      ["vm", "get-instance-view", "--name", param.vm_name, "-g", param.resource_group, "--subscription", param.subscription_id],
      param.query != null ? ["--query", param.query] : [],
    )

    env = param.conn.env
  }

  output "instance_view" {
    description = "The compute virtual machine instance view."
    value       = jsondecode(step.container.get_compute_virtual_machine_instance_view.stdout)
  }
}
