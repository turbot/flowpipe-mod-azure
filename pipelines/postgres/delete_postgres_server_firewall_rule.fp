pipeline "delete_postgres_server_firewall_rule" {
  title       = "Delete PostgreSQL Server Firewall Rule"
  description = "Delete a firewall rule from the specified PostgreSQL server."

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

  param "server_name" {
    type        = string
    description = "The name of the PostgreSQL server."
  }

  param "firewall_rule_name" {
    type        = string
    description = "The name of the firewall rule to be deleted."
  }

  step "container" "delete_postgres_server_firewall_rule" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "postgres", "server", "firewall-rule", "delete",
      "--name", param.firewall_rule_name,
      "--resource-group", param.resource_group,
      "--server-name", param.server_name,
      "--subscription", param.subscription_id,
			"--yes"
    ]

    env = credential.azure[param.cred].env
  }
}
