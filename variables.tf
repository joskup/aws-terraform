variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos."
  type        = string
  default     = "us-east-1" # Puedes cambiar a tu región preferida
}

variable "project_name" {
  description = "Nombre del proyecto para tags estandarizados."
  type        = string
  default     = "ACME"
}

variable "owner" {
  description = "Dueño del recurso para tags estandarizados."
  type        = string
  default     = "Caleidos-ManagedServices"
}

variable "environment" {
  description = "Entorno del despliegue (ej. Development, Staging, Production)."
  type        = string
  default     = "Development"
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDR blocks para las subredes públicas."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Lista de CIDR blocks para las subredes privadas."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad a usar (mínimo 2)."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"] # Cambiar si la región es diferente
}

variable "key_pair_name" {
  description = "Nombre del par de claves EC2 existente para SSH."
  type        = string
  default     = "caleidos-keypair" # Asegúrate de tener este keypair en tu cuenta AWS
}
