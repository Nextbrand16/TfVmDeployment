# Action Groups Variable
variable "action_groups" {
  type = map(object({
    name                = string
    resource_group_name = string
    short_name          = string
    email_receivers = list(object({
      name  = string
      email = string
    }))
    tags = map(string)
  }))
}

# Metric Alerts Variable
variable "metric_alerts" {
  type = map(object({
    name                = string
    resource_group_name = string
    scopes              = list(string)
    description         = string
    frequency           = string
    window_size         = string
    severity            = number
    target_resource_location = string
    target_resource_type = string
    
    criteria = list(object({
      metric_namespace = string
      metric_name      = string
      aggregation      = string
      operator         = string
      threshold        = number
    }))
    action_group_ids = list(string)
    tags             = map(string)
  }))
}
/*
# Scheduled Query Rules Variable
variable "scheduled_query_rules" {
  description = "Scheduled query rules configuration"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string  # Location of the rule
    description         = string
    frequency           = string
    severity            = number
    time_window         = string  # Time window for evaluation
    data_source_id      = string  # Log Analytics Workspace ID
    query               = string
    action_group_ids    = list(string)
    operator            = string  # Operator for threshold comparison ("GreaterThan", "LessThan", etc.)
    threshold           = number  # Numeric threshold value
    tags                = map(string)
  }))
}
*/

