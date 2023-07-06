
# Create the AWS WAF WebACL
resource "aws_wafv2_web_acl" "api_waf" {
  name  = "${var.waf_name}"
  scope = "${var.scope}"
  description = "${var.waf_description}"

  default_action {
    allow {}
  }

  rule {
    name     = "BotProtectionRule"
    priority = 1

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
      }
    }

    
    visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "bot-waf-metric-name"
    sampled_requests_enabled   = false
  }

  }

     visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "api-waf-metric-name"
    sampled_requests_enabled   = false
  }

}