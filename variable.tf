variable "tfc_vpc_workspace_name" {
  description = "Name of the VPC workspace"
  type        = string
  default     = "vpc-dev"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ansible_key" {
  description = "Public key ansible"
  type = string
  default = ""
}