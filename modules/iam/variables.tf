variable "project_name" { type = string }
variable "environment"  { type = string }

# optional: only set when you actually use artifacts bucket
variable "artifacts_bucket_arn" {
  type    = string
  default = null
}