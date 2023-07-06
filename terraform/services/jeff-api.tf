module "jeff-api" {
  source = "../modules/api-gateway"
  api_name = "jeff-api-gateway-v1"
  description = "This is v1 gateway for jeff"
  path = "jeff"
  stage_name = "Dev"
  type = "MOCK"
  http_method = "GET"
  authorize_name = "jeff-cognito"
  authorize_type = "COGNITO_USER_POOLS"
  user_pool_name = "jeff-cognito-user-api"
}
