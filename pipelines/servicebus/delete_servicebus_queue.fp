pipeline "delete_servicebus_queue" {
  title       = "Delete Servicebus Queue"
  description = "Delete a queue from the specified namespace in a resource group."

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

  step "container" "delete_servicebus_queue" {
    image = "my-azure-image"
    cmd   = ["servicebus", "queue", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.queue_name, "--namespace-name", param.namespace_name]

    env = credential.azure[param.cred].env
  }

  output "queue" {
    description = "The deleted servicebus queue details."
    value       = jsondecode(step.container.delete_servicebus_queue.stdout)
  }
}
