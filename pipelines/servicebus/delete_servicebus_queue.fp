pipeline "delete_servicebus_queue" {
  title       = "Delete Service Bus Queue"
  description = "Delete a queue from the specified namespace in a resource group."

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

  param "queue_name" {
    type        = string
    description = "The queue name."
  }

  param "namespace_name" {
    type        = string
    description = "The namespace name."
  }

  step "container" "delete_servicebus_queue" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["servicebus", "queue", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.queue_name, "--namespace-name", param.namespace_name]

    env = param.conn.env
  }

  output "queue" {
    description = "The deleted queue details."
    value       = jsondecode(step.container.delete_servicebus_queue.stdout)
  }
}
