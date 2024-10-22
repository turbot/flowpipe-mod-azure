pipeline "stop_kusto_cluster" {
  title       = "Stop Kusto Cluster"
  description = "Stop an Azure Kusto Cluster."

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
  }

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "cluster_name" {
    type        = string
    description = "The name of the Kusto cluster."
  }

  step "container" "stop_kusto_cluster" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["kusto", "cluster", "stop", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.cluster_name]

    env = param.conn.env
  }

}
