pipeline "delete_compute_snapshot" {
  title       = "Delete Compute Snapshot"
  description = "Delete a compute snapshot."

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

  param "snapshot_name" {
    type        = string
    description = "The name of the compute snapshot that is being deleted."
  }

  step "container" "delete_compute_snapshot" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["snapshot", "delete", "-g", param.resource_group, "-n", param.snapshot_name, "--subscription", param.subscription_id]

    env = param.conn.env
  }

}
