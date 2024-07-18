pipeline "delete_kusto_cluster" {
  title       = "Delete Kusto Cluster"
  description = "Delete an Azure Kusto Cluster."

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "cluster_name" {
    type        = string
    description = "The name of the Kusto cluster."
  }

  step "container" "delete_kusto_cluster" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["kusto", "cluster", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.cluster_name, "--yes"]

    env = credential.azure[param.cred].env
  }
}
