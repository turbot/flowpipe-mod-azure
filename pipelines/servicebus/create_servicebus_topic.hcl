pipeline "create_servicebus_topic" {
  title       = "Create Servicebus Topic"
  description = "Create a topic in the specified namespace."

  param "subscription_id" {
    type        = string
    description = "Azure Subscription Id."
    default     = var.subscription_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "resource_group" {
    type        = string
    description = "Azure Resource Group."
    default     = var.resource_group
    # TODO: Add once supported
    #sensitive   = true
  }

  param "tenant_id" {
    type        = string
    description = "The Microsoft Entra ID tenant (directory) ID."
    default     = var.tenant_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = "A client secret that was generated for the App Registration."
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = "The client (application) ID of an App Registration in the tenant."
    default     = var.client_id
    # TODO: Add once supported
    #sensitive   = true
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

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stdout" {
    description = "Servicebus topic details."
    value       = jsondecode(step.container.create_servicebus_topic.stdout)
  }

  output "stderr" {
    description = "Servicebus topic error."
    value       = step.container.create_servicebus_topic.stderr
  }
}
