# modules/services/variables.tf
variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "bastion_security_group_id" {
  type = string
}

variable "ec2_security_group_id" {
  type = string
}

variable "iam_ec2_role_arn" {
  type = string
}

variable "key_pair_name" {
  type = string
}
