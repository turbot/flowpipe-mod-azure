pipeline "delete_kubernetes_cluster" {
  title       = "Delete Kubernetes Cluster"
  description = "Delete an Azure Kubernetes Cluster."

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
    description = "The name of the Kubernetes cluster."
  }

  step "container" "delete_kubernetes_cluster" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["aks", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.cluster_name, "--yes"]

    env = param.conn.env
  }
}
