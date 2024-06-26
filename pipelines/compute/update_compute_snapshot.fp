pipeline "update_compute_snapshot" {
  title       = "Update Compute Snapshot"
  description = "Update a compute snapshot."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
  }

	param "sku" {
    type        = string
    description = "The SKU tier to be updated."
  }

  param "snapshot_name" {
    type        = string
    description = "The name of the compute snapshot that is being deleted."
  }

  step "container" "update_compute_snapshot" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["snapshot", "update", "-g", param.resource_group, "-n", param.snapshot_name, "--subscription", param.subscription_id, "--sku", param.sku]

    env = credential.azure[param.cred].env
  }

}
