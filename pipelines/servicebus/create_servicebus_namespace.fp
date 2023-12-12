pipeline "create_servicebus_namespace" {
  title       = "Create Servicebus Namespace"
  description = "Create a Service Bus namespace."

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

  param "namespace_name" {
    type        = string
    description = "Name of Namespace."
  }

  step "container" "create_servicebus_namespace" {
    image = "my-azure-image"
    cmd   = ["servicebus", "namespace", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.namespace_name]

    env = credential.azure[param.cred].env
  }

  output "namespace" {
    description = "The created servicebus namespace details."
    value       = jsondecode(step.container.create_servicebus_namespace.stdout)
  }
}
