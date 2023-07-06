output "api_url" {
  description = "URL of the API Gateway"
  value       = "${aws_api_gateway_stage.JeffTestStage.invoke_url}"
}

output "stage_url" {
  description = "Stage URL"
  value       = "${aws_api_gateway_stage.JeffTestStage.invoke_url}"
}

