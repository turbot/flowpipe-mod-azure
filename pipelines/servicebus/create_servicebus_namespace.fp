pipeline "create_servicebus_namespace" {
  title       = "Create Servicebus Namespace"
  description = "Create a Service Bus namespace."

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

  param "namespace_name" {
    type        = string
    description = "The namespace name."
  }

  step "container" "create_servicebus_namespace" {
    image = "my-azure-image"
    cmd   = ["servicebus", "namespace", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.namespace_name]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "servicebus_namespace" {
    description = "The created servicebus namespace details."
    value       = step.container.create_servicebus_namespace.stdout
  }
}
