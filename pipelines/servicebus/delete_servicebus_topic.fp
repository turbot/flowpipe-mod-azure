pipeline "delete_servicebus_topic" {
  title       = "Delete Servicebus Topic"
  description = "Delete a topic in the specified namespace."

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

  param "topic_name" {
    type        = string
    description = "The topic name."
  }

  param "namespace_name" {
    type        = string
    description = "The namespace name."
  }

  step "container" "delete_servicebus_topic" {
    image = "my-azure-image"
    cmd   = ["servicebus", "topic", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.topic_name, "--namespace-name", param.namespace_name]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "servicebus_topic" {
    description = "The deleted servicebus topic details."
    value       = step.container.delete_servicebus_topic.stdout
  }
}
