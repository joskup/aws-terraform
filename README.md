# Reto Técnico: Cloud Specialist (Soporte) - Caleidos

Este repositorio contiene la solución al reto técnico propuesto por Caleidos para el rol de Cloud Specialist. La solución implementa una infraestructura base en AWS para el cliente ACME utilizando Terraform.

## Requisitos Previos

Antes de comenzar, asegúrate de tener lo siguiente instalado y configurado:

1.  **AWS CLI**: Configurado con credenciales de una cuenta de AWS con permisos suficientes.
2.  **Terraform**: Versión 1.0.0 o superior.

## Estructura del Proyecto

* `.gitignore`: Archivo para ignorar archivos generados por Terraform.
* `README.md`: Documentación del proyecto.
* `main.tf`: Archivo principal de Terraform que orquesta la carga de otros módulos.
* `variables.tf`: Define las variables de entrada globales para la infraestructura.
* `outputs.tf`: Define las salidas importantes de la infraestructura desplegada.
* `modules/`: Directorio que contiene los módulos de Terraform para cada componente de la infraestructura:
    * `network/`: Módulo para la configuración de VPC, subredes, Internet Gateway y NAT Gateway.
    * `security/`: Módulo para la definición de Security Groups.
    * `iam/`: Módulo para la configuración de roles y políticas IAM.
    * `services/`: Módulo para la creación de buckets S3 y instancias EC2.
* `architecture.png`: Diagrama de la arquitectura propuesta.
* `risks_and_mitigation.md`: Documento con la identificación de riesgos y sus estrategias de mitigación.

## Pasos para Levantar la Infraestructura

1.  **Clonar el Repositorio:**
    ```bash
    git clone <URL_DEL_REPOSITORIO>
    cd <NOMBRE_DEL_REPOSITORIO>
    ```

2.  **Inicializar Terraform:**
    ```bash
    terraform init
    ```
    Este comando descarga los plugins de proveedor necesarios (AWS en este caso) y configura el backend si está especificado.

3.  **Planificar la Infraestructura:**
    ```bash
    terraform plan
    ```
    Revisa el plan para asegurarte de que Terraform va a crear los recursos esperados.

4.  **Aplicar la Infraestructura:**
    ```bash
    terraform apply
    ```
    Confirma con `yes` cuando se te solicite para iniciar el despliegue de los recursos.

## Cómo Acceder a los Servicios Desplegados

### 1. Acceso a la Instancia EC2 (Ubuntu/Amazon Linux 2) a través del Bastion Host

La instancia EC2 se encuentra en una subred privada y es accesible únicamente a través del Bastion Host, que reside en la subred pública.

1.  **Obtener la IP Pública del Bastion Host:**
    Después de `terraform apply`, la IP pública del Bastion Host estará disponible en las salidas de Terraform.
    ```bash
    terraform output bastion_public_ip
    ```

2.  **Acceso SSH al Bastion Host:**
    Asegúrate de tener la clave SSH privada (`caleidos-keypair.pem`) utilizada para la creación de las instancias.
    ```bash
    ssh -i caleidos-keypair.pem ubuntu@<IP_PUBLICA_BASTION_HOST>
    ```
    (Usa `ec2-user` si elegiste Amazon Linux 2 como AMI).

3.  **Acceso SSH desde el Bastion Host a la Instancia Privada:**
    Una vez dentro del Bastion Host, necesitarás reenviar tu clave SSH para conectarte a la instancia privada.
    * **Opción A: Reenvío de Agente SSH (Recomendado)**
        Desde tu máquina local, al conectarte al Bastion Host, usa la opción `-A`:
        ```bash
        ssh -A -i caleidos-keypair.pem ubuntu@<IP_PUBLICA_BASTION_HOST>
        ```
        Una vez dentro del Bastion Host, conéctate a la instancia privada usando su IP privada (obtenida de `terraform output private_ec2_private_ip`):
        ```bash
        ssh ubuntu@<IP_PRIVADA_EC2>
        ```
    * **Opción B: Copiar la Clave Privada (Menos Seguro)**
        Copia la clave privada (`caleidos-keypair.pem`) al Bastion Host y luego conéctate a la instancia privada. **Esta opción no es recomendada para entornos de producción.**

### 2. Acceso al Bucket S3

El bucket S3 `acme-artifacts-bucket-<ID_ALEATORIO>` puede ser accedido a través de la Consola de AWS, AWS CLI o SDKs, dependiendo de los permisos del usuario o rol IAM que esté utilizando. El rol IAM `acme_ec2_s3_cloudwatch_ssm_role` asignado a la instancia EC2 permite acceso a este bucket.

Para listar el contenido del bucket desde la instancia EC2:
```bash
aws s3 ls s3://$(terraform output s3_bucket_name)
```

## Limpieza de la Infraestructura

Para destruir todos los recursos creados por Terraform:

```bash
terraform destroy
```
Confirma con `yes` cuando se te solicite.

## Tags Estandarizadas

Todos los recursos importantes han sido etiquetados con los siguientes tags:
* `Project`: `ACME`
* `Owner`: `Caleidos-ManagedServices`
* `Environment`: `Development` (puede ser una variable configurable para otros entornos)
