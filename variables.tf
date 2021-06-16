variable "vpc_name" {
  type    = string
  default = "test-vpc"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "cluster_names" {
  description = "Names of the EKS clusters deployed in this VPC."
  type        = list(string)
  default     = []
}
