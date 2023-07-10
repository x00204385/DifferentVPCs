variable "subnets" {
  description = "Subnet ids into which the EC2 instances are launched"
  type        = list(string)
  default     = null
}

variable "instance-ami" {
  description = "The AMI used to create the instances"
  type = string
  default = "ami-0cc4e06e6e710cd94"
}

variable "key-pair" {
  default = "tud-aws"
}

variable "security_group_ids" {
  default = []
}
