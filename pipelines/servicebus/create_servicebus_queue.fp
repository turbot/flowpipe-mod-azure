pipeline "create_servicebus_queue" {
  title       = "Create Servicebus Queue"
  description = "Create a Service Bus queue. This operation is idempotent"

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
    default     = var.subscription_id
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
    default     = var.resource_group
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
    image = "my-azure-image"
    cmd   = ["servicebus", "queue", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.queue_name, "--namespace-name", param.namespace_name]

    env = credential.azure[param.cred].env
  }

  output "queue" {
    description = "The created servicebus queue details."
    value       = jsondecode(step.container.create_servicebus_queue.stdout)
  }
}
