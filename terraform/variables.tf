variable "aws_region" {
  type = string
  description = "Specified AWS Region"
  default = "us-east-1"
}

variable "runtimeEnv" {
  type =string
  description = "Run time environment"
  default = "nodejs16.x"
}
