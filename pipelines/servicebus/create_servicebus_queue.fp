pipeline "create_servicebus_queue" {
  title       = "Create Service Bus Queue"
  description = "Create a Service Bus queue. This operation is idempotent"

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

  step "container" "create_servicebus_queue" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["servicebus", "queue", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.queue_name, "--namespace-name", param.namespace_name]

    env = param.conn.env
  }

  output "queue" {
    description = "The created queue details."
    value       = jsondecode(step.container.create_servicebus_queue.stdout)
  }
}
