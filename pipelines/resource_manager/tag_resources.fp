pipeline "tag_resources" {
  title       = "Apply Resource Tags"
  description = "Apply tags to a specific Azure resource."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "tags" {
    type        = map
    description = "The tags to be applied on the resource. Example: {key1: value1, key2: value2}."
  }

  param "resource_id" {
    type        = string
    description = "The resource identifier for the entity being tagged. A resource, a resource group or a subscription may be tagged."
  }

  param "incremental" {
    type        = bool
    description = "If true, the tags will be merged with the existing tags. If false, the existing tags will be replaced with the new tags."
    default     = true
  }

  step "container" "tag_resources" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = concat(
      ["resource", "tag", "--ids", param.resource_id], 
      param.incremental ? ["-i --tags"] : ["--tags"],
      [for key, value in param.tags : "${key}=${value}"]
    )

    env = param.conn.env
  }

  output "tag" {
    description = "The applied resource tags."
    value       = jsondecode(step.container.tag_resources.stdout)
  }
}
