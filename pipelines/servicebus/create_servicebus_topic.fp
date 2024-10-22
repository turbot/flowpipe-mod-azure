pipeline "create_servicebus_topic" {
  title       = "Create Service Bus Topic"
  description = "Create a topic in the specified namespace."

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

  param "topic_name" {
    type        = string
    description = "The topic name."
  }

  param "namespace_name" {
    type        = string
    description = "The namespace name."
  }

  step "container" "create_servicebus_topic" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["servicebus", "topic", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.topic_name, "--namespace-name", param.namespace_name]

    env = param.conn.env
  }

  output "topic" {
    description = "The created topic details."
    value       = jsondecode(step.container.create_servicebus_topic.stdout)
  }
}
