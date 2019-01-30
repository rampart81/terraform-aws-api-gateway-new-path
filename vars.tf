variable "rest_api_id"             {                       } 
variable "parent_id"               {                       } 
variable "path_part"               {                       } 
variable "stage_name"              {                       } 
variable "http_method"             {                       } 
variable "resource_id"             {                       } 
variable "metrics_enabled"         { default = true        } 
variable "logging_level"           { default = "INFO"      } 
variable "data_trace_enabled"      { default = true        } 
variable "lambda_invoke_arn"       {                       } 
variable "lambda_arn"              {                       } 
variable "integration_http_method" { default = "ANY"       } 
variable "authorization"           { default = "NONE"       } 

## This has to be AWS_PROXY for now
variable "integration_type"        { default = "AWS_PROXY" } 
