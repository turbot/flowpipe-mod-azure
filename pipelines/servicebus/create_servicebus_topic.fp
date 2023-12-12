pipeline "create_servicebus_topic" {
  title       = "Create Servicebus Topic"
  description = "Create a topic in the specified namespace."

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

  param "topic_name" {
    type        = string
    description = "The topic name."
  }

  param "namespace_name" {
    type        = string
    description = "The namespace name."
  }

  step "container" "create_servicebus_topic" {
    image = "my-azure-image"
    cmd   = ["servicebus", "topic", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.topic_name, "--namespace-name", param.namespace_name]

    env = credential.azure[param.cred].env
  }

  output "topic" {
    description = "The created servicebus topic details."
    value       = jsondecode(step.container.create_servicebus_topic.stdout)
  }
}
