pipeline "create_servicebus_namespace" {
  title       = "Create Service Bus Namespace"
  description = "Create a Service Bus namespace."

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

  param "namespace_name" {
    type        = string
    description = "Name of Namespace."
  }

  step "container" "create_servicebus_namespace" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["servicebus", "namespace", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.namespace_name]

    env = param.conn.env
  }

  output "namespace" {
    description = "The created namespace details."
    value       = jsondecode(step.container.create_servicebus_namespace.stdout)
  }
}
