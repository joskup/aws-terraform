# modules/iam/outputs.tf
# output "ec2_s3_cloudwatch_ssm_role_arn" {
#   value = aws_iam_role.ec2_s3_cloudwatch_ssm_role.arn
# }



output "iam_ec2_instance_profile_arn" {
  description = "El ARN del perfil de instancia IAM para las EC2."
  value       = aws_iam_instance_profile.ec2_s3_cloudwatch_ssm_profile.arn
}

output "iam_ec2_instance_profile_name" {
  description = "El nombre del perfil de instancia IAM para las EC2."
  value       = aws_iam_instance_profile.ec2_s3_cloudwatch_ssm_profile.name
}