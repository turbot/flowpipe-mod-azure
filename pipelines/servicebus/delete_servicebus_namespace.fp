pipeline "delete_servicebus_namespace" {
  title       = "Delete Servicebus Namespace"
  description = "Delete an existing namespace. This operation also removes all associated resources under the namespace."

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
    description = "The namespace name."
  }

  step "container" "delete_servicebus_namespace" {
    image = "my-azure-image"
    cmd   = ["servicebus", "namespace", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.namespace_name]

    env = credential.azure[param.cred].env
  }

  output "namespace" {
    description = "The deleted servicebus namespace details."
    value       = jsondecode(step.container.delete_servicebus_namespace.stdout)
  }
}
