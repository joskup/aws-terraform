# modules/iam/outputs.tf
output "ec2_s3_cloudwatch_ssm_role_arn" {
  value = aws_iam_role.ec2_s3_cloudwatch_ssm_role.arn
}
