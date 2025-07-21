# Riesgos Identificados y Estrategias de Mitigación

## 1. Riesgos de Seguridad

### a. Acceso SSH al Bastion Host desde cualquier IP (`0.0.0.0/0`)
* **Riesgo:** El Security Group del Bastion Host permite conexiones SSH desde cualquier dirección IP (`0.0.0.0/0`). Esto expone el Bastion Host a ataques de fuerza bruta y escaneos de vulnerabilidades.
* **Mitigación:**
    * **Restringir CIDR:** En un entorno de producción, restringir el CIDR block del Security Group de SSH a las IPs conocidas de los administradores o de la red corporativa.
    * **Uso de AWS VPN/Direct Connect:** Utilizar un servicio de conectividad privada como AWS VPN o Direct Connect para acceder a la VPC, eliminando la necesidad de exponer el Bastion Host a internet.
    * **SSH Key Management:** Asegurar la gestión adecuada de las claves SSH, incluyendo rotación regular y protección de las claves privadas.
    * **AWS Systems Manager Session Manager:** Aunque ya está habilitado, podría ser la única forma de acceso, eliminando la necesidad de abrir el puerto SSH en el Bastion Host.

### b. Permisos de IAM sobreprivilegiados
* **Riesgo:** La política IAM otorgada a la instancia EC2 (`EC2S3CloudWatchSSMPolicy`) usa `"Resource": "*"` para CloudWatch y SSM. Esto otorga acceso a todos los recursos de esos servicios en la cuenta, lo cual no siempre es necesario.
* **Mitigación:**
    * **Principio de Mínimo Privilegio (Least Privilege):** Refinar las políticas IAM para que los permisos se otorguen únicamente a los recursos específicos necesarios (ej., buckets S3 específicos, grupos de logs específicos de CloudWatch, instancias SSM específicas).
    * **Condiciones IAM:** Usar condiciones en las políticas IAM para restringir aún más el acceso, por ejemplo, basándose en tags, IPs de origen, etc.

### c. Falta de monitoreo y auditoría
* **Riesgo:** Sin un monitoreo activo y auditorías de los logs, los incidentes de seguridad o problemas de rendimiento pueden pasar desapercibidos.
* **Mitigación:**
    * **AWS CloudWatch:** Configurar métricas y alarmas de CloudWatch para monitorear el rendimiento de las instancias EC2, el tráfico de red, el uso de S3, etc.
    * **AWS CloudTrail:** Habilitar CloudTrail para registrar todas las llamadas a la API de AWS, lo que permite auditar las acciones realizadas en la cuenta.
    * **AWS Config:** Utilizar AWS Config para monitorear el cumplimiento de la configuración de los recursos y detectar desviaciones.
    * **VPC Flow Logs:** Habilitar VPC Flow Logs para monitorear el tráfico de red dentro de la VPC, ayudando a identificar patrones de tráfico inusuales o posibles intrusiones.

### d. Ausencia de MFA para usuarios raíz y IAM
* **Riesgo:** Las cuentas de usuario sin Autenticación Multifactor (MFA) son más susceptibles a compromisos por robo de credenciales.
* **Mitigación:**
    * **Habilitar MFA:** Exigir MFA para todos los usuarios IAM, especialmente para aquellos con privilegios administrativos, y para la cuenta raíz de AWS.

## 2. Riesgos de Disponibilidad y Resiliencia

### a. Dependencia de una única AZ para NAT Gateway y Bastion Host
* **Riesgo:** Aunque las subredes están en dos AZs, el diseño actual implementa un NAT Gateway y un Bastion Host en una única AZ. Si esa AZ experimenta una interrupción, la conectividad saliente para las subredes privadas y el acceso al Bastion Host se verán afectados.
* **Mitigación:**
    * **NAT Gateway en cada AZ:** Desplegar un NAT Gateway en cada subred pública en cada AZ utilizada. Esto garantiza que las instancias en las subredes privadas siempre tengan una ruta de salida a internet, incluso si una AZ falla. (La solución Terraform ya contempla esto en `modules/network/main.tf` al usar `count` en `aws_nat_gateway`).
    * **Bastion Host Multi-AZ:** Desplegar un Bastion Host adicional en la segunda subred pública de la otra AZ para redundancia. Se puede usar un Auto Scaling Group para el Bastion Host o considerar el uso de un balanceador de carga para distribuir el tráfico entre múltiples Bastion Hosts (aunque para SSH es menos común).

### b. Instancia EC2 única sin Auto Scaling o Balanceo de Carga
* **Riesgo:** La instancia EC2 privada es un único punto de falla. Si la instancia falla o necesita mantenimiento, el servicio que aloja dejará de estar disponible.
* **Mitigación:**
    * **Auto Scaling Group (ASG):** Implementar las instancias EC2 dentro de un Auto Scaling Group que abarque múltiples AZs. Esto asegurará que las instancias se reemplacen automáticamente en caso de falla y que la capacidad se ajuste a la demanda.
    * **Elastic Load Balancer (ELB):** Si la aplicación en la EC2 es accesible externamente (a través del Bastion Host o si fuera pública), un ELB distribuirá el tráfico entre múltiples instancias en un ASG, mejorando la disponibilidad y resiliencia.

## 3. Riesgos Operacionales

### a. Gestión de claves SSH
* **Riesgo:** La gestión manual de claves SSH puede llevar a claves comprometidas, pérdida de acceso o dificultades en la rotación.
* **Mitigación:**
    * **AWS Systems Manager Session Manager:** Priorizar el uso de Session Manager para la conectividad a las instancias EC2. Session Manager no requiere puertos de entrada abiertos ni claves SSH, reduciendo significativamente la superficie de ataque y simplificando la gestión de acceso.
    * **Centralización de Claves:** Si el acceso SSH es indispensable, considerar soluciones de gestión de claves centralizadas.

### b. Ausencia de monitoreo de costos
* **Riesgo:** Sin un monitoreo proactivo de los costos de AWS, se pueden incurrir en gastos inesperados o innecesarios.
* **Mitigación:**
    * **AWS Cost Explorer:** Utilizar AWS Cost Explorer para analizar los costos históricos y proyectados.
    * **Presupuestos de AWS (Budgets):** Configurar presupuestos en AWS para recibir notificaciones cuando los gastos se acerquen o excedan los umbrales definidos.
    * **Etiquetado de Recursos:** Asegurar que todos los recursos estén correctamente etiquetados (como se hace en la solución propuesta) para una asignación y análisis de costos efectivos.

## 4. Riesgos de Gestión y Escalabilidad

### a. Uso de AMIs estáticas
* **Riesgo:** El uso de una AMI estática (`ami-053d2e67adc8d2645`) puede llevar a desactualizaciones de seguridad o software con el tiempo.
* **Mitigación:**
    * **Pipelines de AMI:** Implementar un pipeline de creación de AMIs (ej., con AWS Image Builder o Packer) para generar AMIs actualizadas y endurecidas regularmente, incluyendo parches de seguridad y software preconfigurado.
    * **Parches Automatizados:** Utilizar AWS Systems Manager Patch Manager para automatizar la aplicación de parches de seguridad a las instancias EC2.

### b. Falta de infraestructura como código (IaC) para la configuración de la instancia (User Data)
* **Riesgo:** La configuración inicial de la instancia EC2 (ej., instalación de paquetes, configuración de servicios) no está definida en el código, lo que dificulta la replicación y la consistencia.
* **Mitigación:**
    * **User Data:** Utilizar el bloque `user_data` en la configuración de la instancia EC2 para ejecutar scripts de arranque que instalen y configuren software.
    * **Configuration Management Tools:** Para configuraciones más complejas, integrar herramientas de gestión de configuración como Ansible, Chef, Puppet o AWS Systems Manager State Manager para mantener el estado deseado de las instancias.

Al abordar estos riesgos de manera proactiva, la infraestructura de ACME será más segura, resiliente, eficiente y fácil de gestionar.
