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

variable "iam_instance_profile_name" {
  description = "El nombre del perfil de instancia IAM para las EC2."
  type        = string
}

# variable "key_pair_name" {
#   type = string
#   default     = "terraformkey"
# }

variable "key_pair_name" {
  description = "Nombre del par de claves EC2 existente para SSH."
  type        = string
  default     = "terraformkey" # Solo el nombre del key pair en AWS
}

# variable "caleidos-keypair" {
#   type = string
#   default     = "caleidos-keypair"
# }

# variable "terraformkey_data" {
#   type = string
#   default     = "caleidos-keypair"
# }