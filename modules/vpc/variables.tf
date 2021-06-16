variable "name" {
  type        = string
  description = "A name for this network."
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "availability_zones" {
  description = "The availability zones to create subnets in"
}

variable "cluster_names" {
    type        = list(string)
  default       = []
  description   = "Names of the EKS clusters deployed in this VPC."
  
}