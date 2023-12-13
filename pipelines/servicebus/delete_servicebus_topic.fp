pipeline "delete_servicebus_topic" {
  title       = "Delete Service Bus Topic"
  description = "Delete a topic from the specified namespace and resource group."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
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
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["servicebus", "topic", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.topic_name, "--namespace-name", param.namespace_name]

    env = credential.azure[param.cred].env
  }

  output "topic" {
    description = "The deleted topic details."
    value       = jsondecode(step.container.delete_servicebus_topic.stdout)
  }
}
