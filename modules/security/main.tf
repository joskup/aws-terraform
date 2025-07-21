# modules/security/main.tf
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_name}-${var.environment}-BastionSG"
  description = "Permitir SSH a bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from anywhere (restrict in production)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-BastionSG"
    Project     = var.project_name
    Owner       = var.owner
    Environment = var.environment
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-${var.environment}-EC2SG"
  description = "Permitir HTTP/HTTPS y SSH desde bastion host a instancia EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description = "Allow SSH from Bastion Host"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere (if applicable)"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol     = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere (if applicable)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-EC2SG"
    Project     = var.project_name
    Owner       = var.owner
    Environment = var.environment
  }
}
