pipeline "delete_hdinsight_cluster" {
  title       = "Delete HDInsight Cluster"
  description = "Delete an Azure HDInsight Cluster."

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
    description = "The name of the HDInsight cluster."
  }

  step "container" "delete_hdinsight_cluster" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [ "hdinsight", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.cluster_name, "--yes"]

    env = credential.azure[param.cred].env
  }
}
