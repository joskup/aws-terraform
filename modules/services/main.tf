# modules/services/main.tf
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

resource "aws_s3_bucket" "artifacts_bucket" {
  bucket = "${var.project_name}-${var.environment}-artifacts-bucket-${random_string.bucket_suffix.result}"
  acl    = "private"

  tags = {
    Name        = "${var.project_name}-${var.environment}-ArtifactsBucket"
    Project     = var.project_name
    Owner       = var.owner
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "artifacts_bucket_versioning" {
  bucket = aws_s3_bucket.artifacts_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts_bucket_encryption" {
  bucket = aws_s3_bucket.artifacts_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_key_pair" "caleidos_keypair" {
  key_name   = var.key_pair_name
}

resource "aws_instance" "bastion_host" {
  ami                         = "ami-053d2e67adc8d2645" # Amazon Linux 2 (us-east-1), cambiar si usas otra región/AMI
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_security_group_id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.caleidos_keypair.key_name

  tags = {
    Name        = "${var.project_name}-${var.environment}-BastionHost"
    Project     = var.project_name
    Owner       = var.owner
    Environment = var.environment
  }
}

resource "aws_instance" "private_ec2_instance" {
  ami                         = "ami-053d2e67adc8d2645" # Amazon Linux 2 (us-east-1), cambiar si usas otra región/AMI
  instance_type               = "t2.micro"
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.ec2_security_group_id]
  associate_public_ip_address = false
  iam_instance_profile        = var.iam_ec2_role_arn
  key_name                    = aws_key_pair.caleidos_keypair.key_name

  tags = {
    Name        = "${var.project_name}-${var.environment}-PrivateEC2Instance"
    Project     = var.project_name
    Owner       = var.owner
    Environment = var.environment
  }
}
