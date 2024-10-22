pipeline "stop_network_application_gateway" {
  title       = "Stop Network Application Gateway"
  description = "Stop an Azure Application Gateway."

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

  param "application_gateway_name" {
    type        = string
    description = "The Application Gateway name."
  }

  step "container" "stop_network_application_gateway" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["network", "application-gateway", "stop", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.application_gateway_name]

    env = param.conn.env
  }

}
