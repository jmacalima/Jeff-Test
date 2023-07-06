module "jeff-waf" {
  source = "../modules/waf"
  waf_name = "jeff-waf-api"
  waf_description = "This is for API Gateway"
  scope = "REGIONAL"
  
}
