###########################################################
## API Gateway for the Lambda
###########################################################
resource "aws_api_gateway_resource" "main" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${var.parent_id}"
  path_part   = "${var.path_part}"
}

resource "aws_api_gateway_method" "main" {
  rest_api_id   = "${var.rest_api_id}"
  resource_id   = "${aws_api_gateway_resource.main.id}"
  http_method   = "${var.http_method}"
  authorization = "${var.authorization}"
}

resource "aws_api_gateway_integration" "main" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_method.main.resource_id}"
  http_method = "${aws_api_gateway_method.main.http_method}"

  integration_http_method = "${var.integration_http_method}"
  type                    = "${var.integration_type}"
  uri                     = "${var.lambda_invoke_arn}"
}

resource "aws_api_gateway_deployment" "apigw" {
  depends_on = [
    "aws_api_gateway_integration.main"
  ]

  rest_api_id = "${var.rest_api_id}"
  stage_name  = "${var.stage_name}"
}

###########################################################
## Allowing API Gateway to Access Lambda
###########################################################
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.apigw.execution_arn}/*/*"
}

resource "aws_api_gateway_method_settings" "apigw" {
  rest_api_id = "${var.rest_api_id}"
  stage_name  = "${var.stage_name}"
  method_path = "*/*"

  settings {
    metrics_enabled    = "${var.metrics_enabled}"
    logging_level      = "${var.logging_level}"
    data_trace_enabled = "${var.data_trace_enabled}"
  }

  depends_on = ["aws_api_gateway_deployment.apigw"]
}
