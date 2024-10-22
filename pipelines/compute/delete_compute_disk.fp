pipeline "delete_compute_disk" {
  title       = "Delete Compute Disk"
  description = "Delete a managed disk."

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
    description = "The name of the managed disk that is being deleted."
  }

  step "container" "delete_compute_disk" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["disk", "delete", "--yes", "-g", param.resource_group, "-n", param.disk_name, "--subscription", param.subscription_id]

    env = param.conn.env
  }

}
