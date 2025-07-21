output "vpc_id" {
  description = "El ID de la VPC creada."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Los IDs de las subredes públicas."
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Los IDs de las subredes privadas."
  value       = module.network.private_subnet_ids
}

output "bastion_public_ip" {
  description = "La IP pública del Bastion Host."
  value       = module.services.bastion_public_ip
}

output "private_ec2_private_ip" {
  description = "La IP privada de la instancia EC2 en la subred privada."
  value       = module.services.private_ec2_private_ip
}

output "s3_bucket_name" {
  description = "El nombre del bucket S3 de artefactos."
  value       = module.services.s3_bucket_name
}

output "iam_ec2_instance_profile_arn" { 
  description = "El ARN del perfil de instancia IAM para las EC2." 
  value       = module.iam.iam_ec2_instance_profile_arn
}
