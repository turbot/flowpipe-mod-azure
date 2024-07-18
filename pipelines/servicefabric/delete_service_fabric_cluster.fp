pipeline "delete_service_fabric_cluster" {
  title       = "Delete Service Fabric Cluster"
  description = "Delete a Service Fabric Cluster from the specified resource group."

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

  param "cluster_name" {
    type        = string
    description = "The Service Fabric cluster name."
  }

  step "container" "delete_service_fabric_cluster" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "resource", "delete",
      "--name", param.cluster_name,
      "--resource-type", "Microsoft.ServiceFabric/clusters",
      "--resource-group", param.resource_group,
      "--subscription", param.subscription_id
    ]

    env = credential.azure[param.cred].env
  }

}
