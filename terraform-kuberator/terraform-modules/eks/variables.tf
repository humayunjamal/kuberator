variable "max_size_spot" {
  default = "10"
}

variable "min_size_spot" {
  default = "1"
}

variable "desired_capacity_spot" {
  default = "1"
}

variable "desired_capacity_ondemand" {
  default = "1"
}

variable "max_size_ondemand" {
  default = "6"
}

variable "min_size_ondemand" {
  default = "1"
}

variable "create_az_based_workers" {
  description = "Whether to create each az based workers or not"
  default     = false
}

variable "create_spot_workers" {
  description = "Whether to create spot workers asg or not"
  default     = false
}

variable "cluster-name" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "aws_vpc_net_id" {
  type = "string"
}

variable "aws_private_subnet_ids" {
  type = "list"
}

variable "aws_private_subnet_id_1a" {
  description = "subnet_id_1a"
  default     = ""
}

variable "aws_private_subnet_id_1b" {
  description = "subnet_id_1b"
  default     = ""
}

variable "aws_private_subnet_id_1c" {
  description = "subnet_id_1c"
  default     = ""
}

variable "aws_image_id" {
  type = "string"
}

variable "team_name" {
  type = "string"
}

variable "team_owner" {
  type = "string"
}

variable "instance_type" {
  default = "t2.xlarge"
}

variable "key_name" {
  default = "key_name"
}

variable "max_size_ondemand-system-node" {
  default = "10"
}

variable "min_size_ondemand-system-node" {
  default = "1"
}

variable "desired_capacity_system-node" {
  default = "5"
}

variable "eks-version" {
  default = ""
}
