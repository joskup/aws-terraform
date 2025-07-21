# modules/security/outputs.tf
output "bastion_security_group_id" {
  value = aws_security_group.bastion_sg.id
}

output "ec2_security_group_id" {
  value = aws_security_group.ec2_sg.id
}
