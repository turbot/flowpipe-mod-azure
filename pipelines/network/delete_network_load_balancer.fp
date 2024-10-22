pipeline "delete_network_load_balancer" {
  title       = "Delete Network Load Balancer"
  description = "Delete a network load balancer."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "subscription_id" {
    type        = string
    description = "The Azure subscription ID."
  }

  param "resource_group" {
    type        = string
    description = "The name of the resource group that contains the App Service Plan."
  }

  param "load_balancer_name" {
    type        = string
    description = "The name of the load balancer."
  }

  step "container" "delete_network_load_balancer" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["network", "lb", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.load_balancer_name]

    env = param.conn.env
  }

}
