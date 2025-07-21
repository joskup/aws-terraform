# modules/services/outputs.tf
output "s3_bucket_name" {
  value = aws_s3_bucket.artifacts_bucket.bucket
}

output "bastion_public_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "private_ec2_private_ip" {
  value = aws_instance.private_ec2_instance.private_ip
}
