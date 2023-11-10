pipeline "create_servicebus_namespace" {
  title       = "Create Servicebus Namespace"
  description = "Create a Service Bus namespace."

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
    description = local.tenant_id_param_description
    default     = var.tenant_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
    # TODO: Add once supported
    #sensitive   = true
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

  output "stdout" {
    description = "The standard output stream from the Azure CLI."
    value       = jsondecode(step.container.create_servicebus_namespace.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the Azure CLI."
    value       = step.container.create_servicebus_namespace.stderr
  }
}
