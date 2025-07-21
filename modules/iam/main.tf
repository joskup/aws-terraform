# modules/iam/main.tf
resource "aws_iam_role" "ec2_s3_cloudwatch_ssm_role" {
  name               = "${var.project_name}-${var.environment}-EC2S3CloudWatchSSMRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-EC2S3CloudWatchSSMRole"
    Project     = var.project_name
    Owner       = var.owner
    Environment = var.environment
  }
}

resource "aws_iam_policy" "ec2_s3_cloudwatch_ssm_policy" {
  name        = "${var.project_name}-${var.environment}-EC2S3CloudWatchSSMPolicy"
  description = "Política para permitir acceso a S3, CloudWatch y SSM para EC2"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-${var.environment}-artifacts-bucket-*",
          "arn:aws:s3:::${var.project_name}-${var.environment}-artifacts-bucket-*/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "ssm:StartSession",
          "ssm:TerminateSession",
          "ssm:ResumeSession",
          "ssm:DescribeSessions",
          "ssm:DescribeInstanceInformation",
          "ssm:GetConnectionStatus"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetEncryptionConfiguration"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-EC2S3CloudWatchSSMPolicy"
    Project     = var.project_name
    Owner       = var.owner
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ec2_s3_cloudwatch_ssm_attach" {
  role       = aws_iam_role.ec2_s3_cloudwatch_ssm_role.name
  policy_arn = aws_iam_policy.ec2_s3_cloudwatch_ssm_policy.arn
}

resource "aws_iam_instance_profile" "ec2_s3_cloudwatch_ssm_profile" {
  name = "${var.project_name}-${var.environment}-EC2S3CloudWatchSSMProfile"
  role = aws_iam_role.ec2_s3_cloudwatch_ssm_role.name # <-- Esto debe ser el .name del rol, no el .arn

  tags = {
    Name        = "${var.project_name}-${var.environment}-EC2S3CloudWatchSSMProfile"
    Project     = var.project_name
    Owner       = var.owner
    Environment = var.environment
  }
}
