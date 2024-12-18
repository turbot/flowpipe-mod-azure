pipeline "delete_servicebus_namespace" {
  title       = "Delete Service Bus Namespace"
  description = "Delete an existing namespace. This operation also removes all associated resources under the namespace."

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
    description = "The namespace name."
  }

  step "container" "delete_servicebus_namespace" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["servicebus", "namespace", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.namespace_name]

    env = param.conn.env
  }

  output "namespace" {
    description = "The deleted namespace details."
    value       = jsondecode(step.container.delete_servicebus_namespace.stdout)
  }
}
