```markdown
# Proyecto Cloud Specialist - Caleidos

## Pasos para desplegar:

1. `terraform init`
2. `terraform plan`
3. `terraform apply`

## Acceso:

- Accede a la instancia privada usando el bastion:
  1. `ssh -i <key> ec2-user@<bastion-public-ip>`
  2. Desde bastion: `ssh ec2-user@10.0.11.X`
- O accede por Session Manager con el perfil IAM configurado.

## Diagrama de Arquitectura:

- VPC con 2 subnets públicas, 2 privadas.
- Bastion host en subnet pública
- NAT Gateway para salida de instancias privadas
- EC2 privada sin acceso a Internet directo, usando bastion o SSM.
- S3 para almacenamiento de artefactos.

## Riesgos Mitigados:

- Seguridad: Bastion host restringido, Session Manager habilitado
- IAM: Principio de mínimo privilegio
- Costos: Uso de recursos mínimos, `terraform destroy` recomendado tras pruebas