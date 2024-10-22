pipeline "get_compute_disk" {
  title       = "Get Compute Disk"
  description = "Get information about a disk."

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

  param "disk_name" {
    type        = string
    description = "The name of the Disk."
  }

  step "container" "get_compute_disk" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["disk", "show", "-g", param.resource_group, "-n", param.disk_name, "--subscription", param.subscription_id]

    env = param.conn.env
  }

  output "disk" {
    description = "The compute disk details."
    value       = jsondecode(step.container.get_compute_disk.stdout)
  }
}
