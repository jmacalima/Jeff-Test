

data "aws_cognito_user_pools" "JeffCogPools" {
  name = var.user_pool_name
}


resource "aws_api_gateway_rest_api" "JeffTestAPI" {
  name        = "${var.api_name}"
  description = "${var.description}"
}


resource "aws_api_gateway_resource" "JeffTestResource" {
  rest_api_id = aws_api_gateway_rest_api.JeffTestAPI.id
  parent_id   = aws_api_gateway_rest_api.JeffTestAPI.root_resource_id
  path_part   = "${var.path}"
}


resource "aws_api_gateway_authorizer" "JeffTestAuthorize" {
  name          = "${var.authorize_name}"
  type          = "${var.authorize_type}"
  rest_api_id   = aws_api_gateway_rest_api.JeffTestAPI.id
  provider_arns = data.aws_cognito_user_pools.JeffCogPools.arns
}


resource "aws_api_gateway_method" "JeffTestMethod" {
  rest_api_id   = aws_api_gateway_rest_api.JeffTestAPI.id
  resource_id   = aws_api_gateway_resource.JeffTestResource.id
  http_method   = "${var.http_method}"
  authorization = "${var.authorize_type}"
  authorizer_id = aws_api_gateway_authorizer.JeffTestAuthorize.id
}

resource "aws_api_gateway_method_settings" "settings" {
  rest_api_id = aws_api_gateway_rest_api.JeffTestAPI.id
  stage_name  = aws_api_gateway_stage.JeffTestStage.stage_name
  method_path = "*/*"

  settings {
    # Set throttling values
    throttling_burst_limit = 1000
    throttling_rate_limit  = 5000

    metrics_enabled = true

    # Actually disable throttling
    # throttling_burst_limit = -1
    # throttling_rate_limit  = -1
  }
}

resource "aws_api_gateway_integration" "JeffTestIntegration" {
  rest_api_id = aws_api_gateway_rest_api.JeffTestAPI.id
  resource_id = aws_api_gateway_resource.JeffTestResource.id
  http_method = aws_api_gateway_method.JeffTestMethod.http_method
  type        = "${var.type}"
}


resource "aws_api_gateway_stage" "JeffTestStage" {
  deployment_id = aws_api_gateway_deployment.JeffTestDeployment.id
  rest_api_id   = aws_api_gateway_rest_api.JeffTestAPI.id
  stage_name    = "${var.stage_name}"
}


resource "aws_wafv2_web_acl_association" "JeffWafAssoc" {
  resource_arn = aws_api_gateway_stage.JeffTestStage.arn
  web_acl_arn  = aws_wafv2_web_acl.api_waf.arn
}

resource "aws_api_gateway_deployment" "JeffTestDeployment" {
  depends_on = [aws_api_gateway_integration.JeffTestIntegration]

  rest_api_id = aws_api_gateway_rest_api.JeffTestAPI.id
  stage_name  = "[${var.stage_name}]"

  lifecycle {
    create_before_destroy = true
  }
}