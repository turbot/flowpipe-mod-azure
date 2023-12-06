pipeline "create_servicebus_queue" {
  title       = "Create Servicebus Queue"
  description = "Create a Service Bus queue."

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

  param "tenant_id" {
    type        = string
    description = local.tenant_id_param_description
    default     = var.tenant_id
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
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

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "servicebus_queue" {
    description = "The created servicebus queue details."
    value       = step.container.create_servicebus_queue.stdout
  }
}
